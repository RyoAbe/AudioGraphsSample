//
//  ChartView.swift
//  AudioGraphsSample
//
//  Created by Ryo Abe on 2021/12/20.
//

import UIKit

final class ChartView: UIView {
    @IBOutlet private weak var stackView: UIStackView!
    private let model: ChartModel = {
        let xAxis: ClosedRange<Double> = 0...7
        let yAxis: ClosedRange<Double> = 0...100
        let xArray = Array(Int(xAxis.lowerBound)...Int(xAxis.upperBound))
        let yArray = Array(Int(yAxis.lowerBound)...Int(yAxis.upperBound))
        let data = xArray.map { ChartModel.DataPoint(name: "", x: Double($0), y: .random(in: yAxis)) }

        return ChartModel(
            title: "チャートタイトル",
            summary: "チャートサマリー",
            xAxis: .init(title: "x軸", range: xAxis),
            yAxis: .init(title: "y軸", range: yAxis),
            data: data
        )
    }()
    private lazy var barList: [UIView] = {
        model.data.map { point in
            let bar = UIView(frame: .zero)
            bar.backgroundColor = .systemBlue
            bar.isAccessibilityElement = true
            bar.accessibilityValue = "x=\(Int(point.x)), y=\(Int(point.y))"
            return bar
        }
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        for bar in barList {
            stackView.addArrangedSubview(bar)
        }
    }

    override func updateConstraints() {
        super.updateConstraints()
        for (i, bar) in barList.enumerated() {
            bar.heightAnchor.constraint(equalToConstant: model.data[i].y * (frame.height * 0.01)).isActive = true
        }
    }
}
// チャート
extension ChartView: AXChart {
    // AXChartプロトコルに対応する accessibilityChartDescriptor を実装
    var accessibilityChartDescriptor: AXChartDescriptor? {
        get {
            // X軸を定義
            // （軸のタイトル、範囲、グリッド線（任意）、軸の値の読み上げさせ方を設定）
            let xAxis = AXNumericDataAxisDescriptor(title: model.xAxis.title,
                                                    range: model.xAxis.range,
                                                    gridlinePositions: [],
                                                    valueDescriptionProvider: { value in
                return "\(value)"
            })
            // Y軸を定義
            let yAxis = AXNumericDataAxisDescriptor(title: model.yAxis.title,
                                                    range: model.yAxis.range,
                                                    gridlinePositions: [],
                                                    valueDescriptionProvider: { value in
                return "\(value)"
            })
            // データ系列の定義
            // （系列タイトル、連続性の有無（折れ線グラフの場合は true）、系列のデータを設定）
            let series = AXDataSeriesDescriptor(name: model.title, isContinuous: false, dataPoints: model.data.map { point in
                AXDataPoint(x: point.x,
                            y: point.y,
                            additionalValues: [],
                            label: point.name)
            })
            // 作ったパーツを組み合わせて AXChartDescriptor を作る
            // （棒グラフや折れ線グラフが重なったチャートであれば、複数のデータ系列を指定可能）
            return AXChartDescriptor(title: model.title,
                                     summary: model.summary,
                                     xAxis: xAxis,
                                     yAxis: yAxis,
                                     additionalAxes: [],
                                     series: [series])
        }
        set {}
    }
}
