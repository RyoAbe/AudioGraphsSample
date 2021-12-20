//
//  ChartModel.swift
//  AudioGraphsSample
//
//  Created by Ryo Abe on 2021/12/20.
//

import Foundation

struct ChartModel {
    let title: String
    let summary: String
    let xAxis: Axis
    let yAxis: Axis
    let data: [DataPoint]

    struct Axis {
        let title: String
        let range: ClosedRange<Double>
    }

    struct DataPoint: Identifiable {
        let id: String = UUID().uuidString
        let name: String
        let x: Double
        let y: Double
    }
}
