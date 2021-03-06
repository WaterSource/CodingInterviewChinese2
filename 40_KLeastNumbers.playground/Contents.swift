//==================================================================
// 《剑指Offer——名企面试官精讲典型编程题》代码
//==================================================================
// 面试题40：最小的k个数
// 题目：输入n个整数，找出其中最小的k个数。例如输入4、5、1、6、2、7、3、8
// 这8个数字，则最小的4个数字是1、2、3、4。

import Foundation
import XCTest

class Solution {
    
    /**
     输入n个整数，找出其中最小的k个数。
     解法：通过partition的方式找出
     - Parameters:
        - nums: 数组
        - k: k
     - Returns: 最小的K个数
     */
    func GetLeastNumbers_Solution1(_ nums: [Int], k: Int) -> [Int] {
        var nums = nums
        if nums.count == 0 || k <= 0  || k > nums.count{
            return [Int]()
        }
        var start = 0
        var end = nums.count - 1
        var index = 0
        
        (index, nums) = partition(nums, start: start, end: end)
        
        while index != k - 1 {
            if index > k - 1 {
                end = index - 1
            } else {
                start = index + 1
            }
            (index, nums) = partition(nums, start: start, end: end)
        }
        return Array(nums[..<k])
    }
    /**
     将数组在指定范围内[start，end]分区，使得左边部分数字比右边部分的小
     - Parameters:
        - nums: 数组
        - start: 分区开始索引
        - end: 分区结束索引
     - Returns: index：当前分区的分界索引  newNums:分区之后的新数组
     */
    func partition (_ nums: [Int], start: Int, end: Int) -> (index: Int, newNums: [Int]) {
        if nums.count == 0 || start > end || end > nums.count {
            return (-1, nums)
        }
        if start == nums.count - 1{
            return (start, nums)
        }
        var nums = nums
        var startIndex = start
        var endIndex = end
        let pivot = nums[start]
        startIndex += 1
        while true {
            while nums[startIndex] <= pivot && startIndex < end {
                startIndex += 1
            }
            while nums[endIndex] >= pivot && endIndex > start {
                endIndex -= 1
            }
            if endIndex > startIndex {
                nums = swap(nums, a: startIndex, b: endIndex)
            } else {
                break
            }
        }
        nums = swap(nums, a: start, b: endIndex)
        return (endIndex, nums)
    }
    /**
     交换数组中的两个元素
     - Parameters:
        - nums: 数组
        - a: 索引a
        - b: 索引b
     - Returns: 交换之后的数组
     */
    private func swap(_ nums:[Int], a: Int, b: Int) -> [Int] {
        if nums.count == 0 || a > nums.count || b > nums.count {
            return nums
        }
        var nums = nums
        let temp = nums[a]
        nums[a] = nums[b]
        nums[b] = temp
        return nums
    }
    /**
     输入n个整数，找出其中最小的k个数。
     解法：遍历数组，使用一个最大堆保存最小的k个数（不改变数组，不用一次性全部加载数据，所以适合大数据处理）
     - Parameters:
        - nums: n个整数
        - k: k
     - Returns: 最小的k个数
     */
    func GetLeastNumbers_Solution2(_ nums: [Int], k: Int) -> [Int] {
        var heap = Heap<Int>(sort: >)
        for num in nums {
            if heap.count < k {
                heap.insert(num)
                continue
            }
            if num < heap.peek()! {
                heap.remove()
                heap.insert(num)
            }
        }
        var result = [Int]()
        for _ in 0..<k {
            result.append(heap.remove()!)
        }
        return result
    }
}

class UnitTests: XCTestCase {
    var solution: Solution!
    
    override func setUp() {
        super.setUp()
        solution = Solution()
    }
    //k小于数组长度
    func testCase1() {
        let nums = [4,5,1,6,2,7,3,8]
        let result1 = solution.GetLeastNumbers_Solution1(nums, k: 4).sorted()
        let result2 = solution.GetLeastNumbers_Solution2(nums, k: 4).sorted()
        XCTAssertEqual([1,2,3,4], result1)
        XCTAssertEqual([1,2,3,4], result2)
    }
    //k等于数组长度
    func testCase2() {
        let nums = [4,5,1,6,2,7,3,8]
        let result1 = solution.GetLeastNumbers_Solution1(nums, k: 8).sorted()
        let result2 = solution.GetLeastNumbers_Solution2(nums, k: 8).sorted()
        XCTAssertEqual([1,2,3,4,5,6,7,8], result1)
        XCTAssertEqual([1,2,3,4,5,6,7,8], result2)
    }
    //k大于数组长度
    func testCase3() {
        let nums = [4,5,1,6,2,7,3,8]
        let result1 = solution.GetLeastNumbers_Solution1(nums, k: 10)
        let result2 = solution.GetLeastNumbers_Solution1(nums, k: 10)
        XCTAssertEqual([], result1)
        XCTAssertEqual([], result2)
    }
    //k=1
    func testCase4() {
        let nums = [4,5,1,6,2,7,3,8]
        let result1 = solution.GetLeastNumbers_Solution1(nums, k: 1).sorted()
        let result2 = solution.GetLeastNumbers_Solution1(nums, k: 1).sorted()
        XCTAssertEqual([1], result1)
        XCTAssertEqual([1], result2)
    }
    //k=0
    func testCase5() {
        let nums = [4,5,1,6,2,7,3,8]
        let result1 = solution.GetLeastNumbers_Solution1(nums, k: 0)
        let result2 = solution.GetLeastNumbers_Solution1(nums, k: 0)
        XCTAssertEqual([], result1)
        XCTAssertEqual([], result2)
    }
    //数组中有相同数字
    func testCase6() {
        let nums = [4,5,1,6,2,7,3,8]
        let result1 = solution.GetLeastNumbers_Solution1(nums, k: 2).sorted()
        let result2 = solution.GetLeastNumbers_Solution1(nums, k: 2).sorted()
        XCTAssertEqual([1,2], result1)
        XCTAssertEqual([1,2], result2)
    }
}

UnitTests.defaultTestSuite.run()
