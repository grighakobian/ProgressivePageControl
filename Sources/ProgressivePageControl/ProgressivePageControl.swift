import UIKit

@IBDesignable
open class ProgressivePageControl: UIControl {

    @IBInspectable 
    open var numberOfPages: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var currentPage: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var hidesForSinglePage: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var pageIndicatorTintColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var currentPageIndicatorTintColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }


    @IBInspectable
    open var currentPageIndicatorRadius: CGFloat = 20.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var padding: CGFloat = 9.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var pageRadius: CGFloat = 7.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var lineWidth: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var showLineIndicator: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    open var showCurrentPageIndicator: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    open override var contentVerticalAlignment: UIControl.ContentVerticalAlignment {
        didSet {
            setNeedsLayout()
        }
    }

    open override var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment {
        didSet {
            setNeedsDisplay()
        }
    }

    open func size(forNumberOfPages pageCount: Int) -> CGSize {
        var height = pageRadius
        if showCurrentPageIndicator {
            height = max(currentPageIndicatorRadius, pageRadius)
        }
        var width = (CGFloat(numberOfPages - 1) * padding) + (CGFloat(numberOfPages) * pageRadius)
        if showCurrentPageIndicator {
            width += currentPageIndicatorRadius
        }
        height += 3 * lineWidth
        return CGSize(width: width, height: height)
    }

    open override var intrinsicContentSize: CGSize {
        return size(forNumberOfPages: numberOfPages)
    }

    internal func getStartPoint(in rect: CGRect)-> CGPoint {
        let contentSize = intrinsicContentSize
        let contentHeight = contentSize.height
        var contentWidth = contentSize.width

        if showCurrentPageIndicator {
            contentWidth -= currentPageIndicatorRadius
        }

        let interCurrentPagePadding = (currentPageIndicatorRadius + lineWidth - pageRadius) / 2

        var startPoint = CGPoint.zero
        switch contentVerticalAlignment {
        case .top:
            if showCurrentPageIndicator {
                let topPadding = interCurrentPagePadding
                startPoint.y = rect.minY + topPadding
            } else {
                startPoint.y = rect.minY
            }
        case .center:
            startPoint.y = rect.midY - (3 * lineWidth) / 2
        case .bottom:
            if showCurrentPageIndicator {
                let bottomPadding = pageRadius + interCurrentPagePadding
                startPoint.y = rect.maxY - bottomPadding
            } else {
                startPoint.y = rect.maxY - contentHeight
            }
        case .fill:
            startPoint.y = rect.midY
        @unknown default:
            startPoint.y = rect.midY
        }

        switch contentHorizontalAlignment {
        case .center:
            startPoint.x = rect.midX - contentWidth / 2
        case .fill:
            startPoint.x = rect.midX - contentWidth / 2
        case .left:
            if showCurrentPageIndicator {
                startPoint.x = rect.minX + interCurrentPagePadding
            } else {
                startPoint.x = rect.minX
            }
        case .right:
            if showCurrentPageIndicator {
                startPoint.x = rect.maxX - contentWidth - interCurrentPagePadding
            } else {
                startPoint.x = rect.maxX - contentWidth
            }
        case .leading:
            startPoint.x = rect.minX
        case .trailing:
            startPoint.x = rect.maxX - contentWidth
        @unknown default:
            startPoint.x = (rect.maxX - contentWidth) / 2
        }
        return startPoint
    }

    open override func draw(_ rect: CGRect) {
        if hidesForSinglePage && numberOfPages == 1 {
            return
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.setLineWidth(lineWidth)
        context.setLineJoin(.round)
        context.setLineCap(.round)

        let startPoint = getStartPoint(in: rect)
        var currentPoint = startPoint

        let dotSize = CGSize(width: pageRadius, height: pageRadius)
        let _currentPage = min(max(0, currentPage), numberOfPages - 1)

        for i in 0..<numberOfPages {
            defer {
                currentPoint.x += padding + pageRadius
            }

            if (_currentPage == i) || (_currentPage > i && showLineIndicator)  {
                (currentPageIndicatorTintColor ?? .currentPageIndicatorTintColor).setStroke()
                (currentPageIndicatorTintColor ?? .currentPageIndicatorTintColor).setFill()
            } else {
                (pageIndicatorTintColor ?? .pageIndicatorTintColor).setStroke()
                (pageIndicatorTintColor ?? .pageIndicatorTintColor).setFill()
            }
            // Draw page dots

            context.move(to: currentPoint)
            context.addEllipse(in: CGRect(origin: currentPoint, size: dotSize))
            context.drawPath(using: .fill)
            context.strokePath()

            if (i == _currentPage) {
                // Draw line
                if _currentPage > 0 && showLineIndicator {
                    var lineStartPoint = startPoint
                    lineStartPoint.x += pageRadius / 2
                    lineStartPoint.y += pageRadius / 2

                    var lineEndPoint = currentPoint
                    lineEndPoint.y += pageRadius / 2
                    if showCurrentPageIndicator {
                        lineEndPoint.x -= (currentPageIndicatorRadius - pageRadius) / 2
                    }
                    context.move(to: lineStartPoint)
                    context.addLine(to: lineEndPoint)
                    context.strokePath()
                }

                if showCurrentPageIndicator {
                    // Draw current page circle dot
                    let ellipesSize = CGSize(width: currentPageIndicatorRadius, height: currentPageIndicatorRadius)
                    var ellipsePoint = currentPoint
                    context.move(to: ellipsePoint)
                    ellipsePoint.x = ellipsePoint.x + (pageRadius / 2) - currentPageIndicatorRadius / 2
                    ellipsePoint.y = ellipsePoint.y + (pageRadius / 2) - currentPageIndicatorRadius / 2
                    context.addEllipse(in: CGRect(origin: ellipsePoint, size: ellipesSize))
                    context.strokePath()
                }
            }
        }
    }
}

private extension UIColor {
    class var pageIndicatorTintColor: UIColor {
        return UIColor.black.withAlphaComponent(0.3)
    }

    class var currentPageIndicatorTintColor: UIColor {
        return UIColor.black
    }
}
