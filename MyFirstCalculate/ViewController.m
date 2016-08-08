//
//  ViewController.m
//  MyFirstCalculate
//
//  Created by kjnam on 2016. 8. 8..
//  Copyright © 2016년 kjnam. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize curValue;
@synthesize totalCurValue;
@synthesize curStatusCode;
@synthesize displayLabel;

// 화면 초기화가 끝났을 때 호출
- (void)viewDidLoad {
    [self ClearCalculation];
    [super viewDidLoad];
}

// 메모리가 부족할 때 호출
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 숫자 버튼 클릭 이벤트 처리 메소드
- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *numPoint = [[sender titleLabel]text];
    curInputValue = [curInputValue stringByAppendingFormat:numPoint];

    [self DisplayInputValue:curInputValue];
}

// 기능 버튼 클릭 이벤트 처리 메소드
- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operationText = [[sender titleLabel]text];
    
    if ([@"+"isEqualToString:operationText]) {
        [self Calculation:curStatusCode CurStatusCode:STATUS_PLUS];
    } else if ([@"-"isEqualToString:operationText]) {
        [self Calculation:curStatusCode CurStatusCode:STATUS_MINUS];
    } else if ([@"X"isEqualToString:operationText]) {
        [self Calculation:curStatusCode CurStatusCode:STATUS_MULTIPLY];
    } else if ([@"/"isEqualToString:operationText]) {
        [self Calculation:curStatusCode CurStatusCode:STATUS_DIVISION];
    } else if ([@"C"isEqualToString:operationText]) {
        [self ClearCalculation];
    } else if ([@"="isEqualToString:operationText]) {
        [self Calculation:curStatusCode CurStatusCode:STATUS_RETURN];
    }
}

// 현재 상태에 해당하는 분기 처리 메서드
- (void)Calculation:(kStatusCode)StatusCode CurStatusCode:(kStatusCode)cStatusCode;
{
    switch (StatusCode) {
        case STATUS_DEFAULT:
            [self DefaultCalculation];
            break;
            
        case STATUS_DIVISION:
            [self DivisionCalculation];
            break;
            
        case STATUS_MULTIPLY:
            [self MultiplyCalculation];
            break;
            
        case STATUS_MINUS:
            [self MinusCalculation];
            break;
            
        case STATUS_PLUS:
            [self PlusCalculation];
            break;
            
        default:
            break;
    }
    curStatusCode = cStatusCode;
}

// 초기화 이후 처음 입력된 값에 대한 처리
- (void)DefaultCalculation
{
    curValue = [curInputValue doubleValue];
    totalCurValue = curValue;
    
    [self DisplayCalculationValue];
}

// 입력된 값에 대한 덧셈 처리
- (void)PlusCalculation
{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue + curValue;
    
        [self DisplayCalculationValue];
}

//입력된 값에 대한 뺄셈 처리
- (void)MinusCalculation
{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue - curValue;
    
        [self DisplayCalculationValue];
}

//입력된 값에 대한 곱셈 처리
- (void)MultiplyCalculation
{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue * curValue;
    
    [self DisplayCalculationValue];
}

//입력된 값에 대한 나눗셈 처리
- (void)DivisionCalculation
{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue / curValue;
    
    [self DisplayCalculationValue];
}

// 라벨에 문자열 출력 메소드
- (void)DisplayInputValue:(NSString *)displayText
{
    NSString *CommaText;
    CommaText = [self ConvertComma:displayText];
    [displayLabel setText:CommaText];
}

// 계산 결과를 화면에 출력 메소드
- (void)DisplayCalculationValue
{
    NSString *displayText;
    displayText = [NSString stringWithFormat:@"%g", totalCurValue];
    [self DisplayInputValue:displayText];
    curInputValue = @"";
}

// 천 단위 포맷 메서드
- (NSString *)ConvertComma:(NSString *)data
{
    if (data == nil) return nil;
    if ([data length] <= 3) return data;
    
    NSString *integerString = nil;
    NSString *floatString = nil;
    NSString *minusString = nil;
    
    NSRange pointRage = [data rangeOfString:@"."];
    if (pointRage.location == NSNotFound) {
        integerString = data;
    } else {
        // 소수점 이하 영역 탐색
        NSRange r;
        r.location = pointRage.location;
        r.length = [data length] - pointRage.location;
        floatString = [data substringWithRange:r];
        
        // 정수부 영역 탐색
        r.location = 0;
        r.length = pointRage.location;
        integerString = [data substringWithRange:r];
    }
    
    // 음수부호 탐색
    NSRange minusRage = [integerString rangeOfString:@"-"];
    if (minusRage.location != NSNotFound) {
        minusString = @"-";
        integerString = [integerString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    // 세자리 단위로 콤마 표시
    NSMutableString *integerStringCommaInserted = [[NSMutableString alloc] init];
    NSUInteger integerStringLength = [integerString length];
    int idx = 0;
    while (idx < integerStringLength) {
        [integerStringCommaInserted appendFormat:@"%C", [integerString characterAtIndex:idx]];
        if ((integerStringLength - (idx+1)) % 3 == 0 && integerStringLength != (idx+1)) {
            [integerStringCommaInserted appendString:@","];
        }
        idx++;
    }
    
    NSMutableString *returnString = [[NSMutableString alloc]init];
    if (minusString != nil) {
        [returnString appendString:minusString];
    }
    if (integerStringCommaInserted != nil) {
        [returnString appendString:integerStringCommaInserted];
    }
    if (floatString != nil) {
        [returnString appendString:floatString];
    }
    
    return returnString;
}

// 화면 초기화
- (void)ClearCalculation
{
    curInputValue = @"";
    curValue = 0;
    totalCurValue = 0;
    
    [self DisplayInputValue:curInputValue];
    
    curStatusCode = STATUS_DEFAULT;
}

@end
