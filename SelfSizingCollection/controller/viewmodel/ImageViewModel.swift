import UIKit

struct ImageViewModel: Identifiable, Hashable
{
    let altText: String
    let id: String
    let url: String
}

extension ImageViewModel
{
    static func jennefer() -> Self {
        ImageViewModel(altText: "Jennefer in the forest",
                       id: "1",
                       url: "https://64.media.tumblr.com/5ad2eb3b0d8e6347577ef38922d6d2a2/a0ee4f6d1e63c9c7-57/s540x810/9d10f45b956e6715d33c462477a959750f0e3f74.jpg")
    }
    static func gerald() -> Self {
        ImageViewModel(altText: "Gerald in a bath",
                       id: "2",
                       url: "https://44.media.tumblr.com/1b8f637969dfe9943c7fc832d02bbe42/a0ee4f6d1e63c9c7-b5/s540x810_f1/965d50cc8bd5af2d771051023dfd6189c6802956.gifv")
    }
    static func cast() -> Self {
        ImageViewModel(altText: "Cast",
                       id: "3",
                       url: "https://64.media.tumblr.com/81faf2881f439b2f9aabbdc0364bcff7/12a2c3ef47d4ded4-d0/s1280x1920/ca61645dd7dab69caa7b3b120fbb016c1af9b821.jpg")
    }
    static func redCarpet() -> Self {
        ImageViewModel(altText: "Red Carpet",
                       id: "4",
                       url: "https://64.media.tumblr.com/033b9426f1044c713e81f847564806d6/2ba665169ecaa759-c5/s1280x1920/36d5cbdf85e0199589cb466e831c46de5bf12a6a.jpg")
    }
    static func ciri() -> Self {
        ImageViewModel(altText: "Ciri",
                       id: "5",
                       url: "https://64.media.tumblr.com/49ccbb6531055261462b88f69b314078/e8f9449e30144b21-8a/s500x750/d24a6423ffc8568bc1662cc618aff8ab228c2810.gifv")
    }
}
