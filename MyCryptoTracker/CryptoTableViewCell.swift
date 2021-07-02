//
//  CryptoTableViewCell.swift
//  MyCryptoTracker
//
//  Created by Jesther Silvestre on 7/1/21.
//

import UIKit



class CryptoTableViewCell: UITableViewCell {
    static let IDENTIFIER = "CryptoTableViewCell"
    //Subviews
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private let symbolLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    private let priceLabel:UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    private let iconView:UIImageView = {
        let imageView = UIImageView()
        //imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
       return imageView
    }()
    //Init
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(iconView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let size:CGFloat = contentView.frame.size.height/1.1
        
        iconView.frame = CGRect(x: 20,
                                y: (contentView.frame.size.height-size)/2,
                                 width: size,
                                 height: size)
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        symbolLabel.sizeToFit()
        
        nameLabel.frame = CGRect(x: 30 + size,
                                 y: 0,
                                 width: contentView.frame.size.width/2,
                                 height: contentView.frame.size.height/2)
        symbolLabel.frame = CGRect(x: 30 + size,
                                   y: contentView.frame.size.height/2,
                                   width: contentView.frame.size.width/2,
                                   height: contentView.frame.size.height/2)
        priceLabel.frame = CGRect(x: contentView.frame.size.width/2,
                                  y: 0,
                                  width: (contentView.frame.size.width/2)-15,
                                  height: contentView.frame.size.height)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        
    }
    
    //Configure
    func configure(with viewModel:CryptoTableViewCellViewModel){
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        symbolLabel.text = viewModel.symbol
        
        if let data = viewModel.iconData{
            iconView.image = UIImage(data: data)
        }
        else if let url = viewModel.iconUrl{
            let task = URLSession.shared.dataTask(with: url){ [weak self] data, _,_ in
                if let data = data{
                    viewModel.iconData = data
                    DispatchQueue.main.async {
                        self?.iconView.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
}
