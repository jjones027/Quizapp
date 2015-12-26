
#import "WordPuzzle.h"

@interface NSMutableArray (Shuffle)

- (void)shuffle;

@end

@implementation NSMutableArray (Shuffle)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform((int)nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end

@interface WordPuzzle()

@property (nonatomic, strong) NSString *originalWord;
@property (nonatomic, strong) NSString *workingWord;
@property (nonatomic, strong) NSMutableArray *songLetters;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *wordLabels;

@property (nonatomic, assign) int randomCount;
@property (nonatomic, assign) int currentLetterIndex;


@end

@implementation WordPuzzle

@synthesize originalWord,workingWord,songLetters,buttons,wordLabels,randomCount,currentLetterIndex;
@synthesize questionGridCellSize,answerGridCellSize;

- (id)initWithWord:(NSString *)str andRandomCharacterToInjectCount:(int)count
{
    self = [super init];
    if(self)
    {
        originalWord = str.lowercaseString;
        randomCount = count;
        currentLetterIndex = 0;
        questionGridCellSize = CGSizeMake(40, 40);
        answerGridCellSize = CGSizeMake(40, 40);
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    songLetters = [NSMutableArray new];
    buttons = [NSMutableArray new];
    wordLabels = [NSMutableArray new];

    workingWord = [originalWord stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *mu = [NSMutableString stringWithString:workingWord];
    
    NSString *alphabet  = @"ABCDEFGHIJKLMNOPQRSTUVWXZY";
    for (NSUInteger i = 0; i < randomCount; i++)
    {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet.lowercaseString characterAtIndex:r];
        [mu appendFormat:@"%C", c];
    }
    for (int i = 0; i < [mu length]; i++)
    {
        NSString *ch = [mu substringWithRange:NSMakeRange(i, 1)];
        if (![ch isEqualToString:@" "])
        {
            [songLetters addObject:ch];
        }
    }
    [songLetters shuffle];
}

- (void)addQuestionButtonsGridWithFrame:(CGPoint)origin showOn:(UIView *)viewToAdd
{
    CGFloat xValue = origin.x;
    CGFloat yValue = origin.y;

    for(int i=0;i<songLetters.count;i++)
    {
        UIButton *WordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [WordButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:questionGridCellSize.width/2]];
        [WordButton setFrame:CGRectMake(xValue, yValue, questionGridCellSize.width, questionGridCellSize.height)];
        [WordButton setBackgroundColor:[UIColor blackColor]];
        [WordButton setTitle:[NSString stringWithFormat:@"%@",songLetters[i]] forState:UIControlStateNormal];
        [WordButton addTarget:self action:@selector(wordClick:) forControlEvents:UIControlEventTouchUpInside];
        
        xValue +=questionGridCellSize.width+5;
        if (xValue > viewToAdd.frame.size.width-questionGridCellSize.width)
        {
            yValue+= questionGridCellSize.height+5;
            xValue = origin.x;
        }
        [viewToAdd addSubview:WordButton];
        [buttons addObject:WordButton];
    }
}

- (void)addAnswerGridWithFrame:(CGPoint)origin showOn:(UIView *)viewToAdd
{
    CGFloat xValue = origin.x;
    CGFloat yValue = origin.y;;
    
    for(int i=0;i<originalWord.length;i++)
    {
        if ([[NSString stringWithFormat:@"%C", [originalWord characterAtIndex:i]] isEqualToString:@" "])
        {
            yValue+= questionGridCellSize.height+5;
            xValue = origin.x;
        }
        else
        {
            UILabel *answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(xValue, yValue,
                                                                            questionGridCellSize.width, questionGridCellSize.height)];
            answerLabel.text = [NSString stringWithFormat:@"%C", [originalWord characterAtIndex:i]];
            answerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:questionGridCellSize.width/2];
            [answerLabel setBackgroundColor:[UIColor clearColor]];
            [answerLabel setTextColor:[UIColor blackColor]];
            answerLabel.textAlignment = NSTextAlignmentCenter;
            answerLabel.hidden = YES;
            
            UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(xValue, yValue,
                                                                                 questionGridCellSize.width, questionGridCellSize.height)];
            [bgImage setImage:[UIImage imageNamed:@"roundedSquareCell"]];
            
            xValue +=questionGridCellSize.width+5;
            if (xValue > viewToAdd.frame.size.width-questionGridCellSize.width)
            {
                yValue+= questionGridCellSize.height+5;
                xValue = origin.x;
            }
            [wordLabels addObject:answerLabel];
            [viewToAdd addSubview:bgImage];
            [viewToAdd addSubview:answerLabel];
        }
    }
}

- (IBAction)wordClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSString *clickedLetter = btn.currentTitle;
    /*if ([originalWord rangeOfString:[NSString stringWithFormat:@"%@",clickedLetter]].location != NSNotFound)
    {*/
        // Check if the clicked letter matches the correct letter for currentLetterIndex
        //if ([originalWord characterAtIndex:currentLetterIndex] != [clickedLetter characterAtIndex:0]) {
            //NSLog(@"Not the right letter for this one");
            //[self.delegate didSelectWrongTile:clickedLetter];
            // Let them finish the puzzle and check for validity at the end
            //return;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCorrectTile:)])
        {
            [self.delegate didSelectCorrectTile:clickedLetter];
        }
        if (btn.hidden == NO)
        {
            btn.hidden = YES;
        }
        /*
        for (UILabel* wordLabel in wordLabels)
        {
            if ([wordLabel.text isEqualToString:clickedLetter] && wordLabel.hidden == YES)
            {
                wordLabel.hidden = NO;
                break;
            }
        }
         */

        ((UILabel*)wordLabels[currentLetterIndex]).text = [NSString stringWithFormat:@"%@", clickedLetter];
        [wordLabels[currentLetterIndex] setHidden:false];
        currentLetterIndex++;
        
        /*NSRange rOriginal = [workingWord rangeOfString: clickedLetter];
        if (NSNotFound != rOriginal.location) {
            workingWord = [workingWord
                        stringByReplacingCharactersInRange: rOriginal
                        withString:                         @""];
        }*/
        
        //workingWord = [workingWord stringByReplacingOccurrencesOfString:clickedLetter withString:@""];
        if (workingWord.length == currentLetterIndex)
        {
            // Now check if the words are the same
            int i = 0;
            for (UILabel* wordLabel in wordLabels)
            {
                if ([wordLabel.text characterAtIndex:0] != [originalWord characterAtIndex:i])
                {
                    if (![wordLabel.text isEqualToString:@" "]) {
                        NSLog(@"Strings do not match");
                    }
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishSolvingPuzzle)])
            {
                [self.delegate didFinishSolvingPuzzle];
            }
        }
    /*}
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectWrongTile:)])
        {
            [self.delegate didSelectWrongTile:clickedLetter];
        }
    }*/
}

@end