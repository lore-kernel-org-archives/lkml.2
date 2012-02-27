Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2B0IMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:12:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48077 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2B0IMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:12:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.160.131 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <20120227072705.GA19429@bnru02>
References: <1329333578-31773-1-git-send-email-danny.kukawka@bisect.de>
	<20120227072705.GA19429@bnru02>
Date: Mon, 27 Feb 2012 09:12:41 +0100
Message-ID: <CACRpkdYV-EoJNPei9JbM=xmF8i8J5sd33uE70cAMF7p-h42Zzg@mail.gmail.com>
Subject: Re: [PATCH] arch/arm/mach-ux500/board-mop500-u8500uib.c: included
 linux/gpio.h twice
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Danny Kukawka <danny.kukawka@bisect.de>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 8:27 AM, Srinidhi Kasagar
<srinidhi.kasagar@stericsson.com> wrote:
> On Wed, Feb 15, 2012 at 20:19:38 +0100, Danny Kukawka wrote:
>> arch/arm/mach-ux500/board-mop500-u8500uib.c included 'linux/gpio.h'
>> remove the duplicate.
>>
>> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
>> ---
>>  arch/arm/mach-ux500/board-mop500-u8500uib.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-ux500/board-mop500-u8500uib.c b/arch/arm/mach-ux500/board-mop500-u8500uib.c
>> index feb5744..ead91c9 100644
>> --- a/arch/arm/mach-ux500/board-mop500-u8500uib.c
>> +++ b/arch/arm/mach-ux500/board-mop500-u8500uib.c
>> @@ -8,7 +8,6 @@
>>  #include <linux/kernel.h>
>>  #include <linux/init.h>
>>  #include <linux/i2c.h>
>> -#include <linux/gpio.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/mfd/tc3589x.h>
>>  #include <linux/input/matrix_keypad.h>
>
> Thanks,
>
> Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
>
> Linus W, would you please pick if you have not noticed this.

Thanks for the reminder, I've picked it up and merged
to my ux500-core branch.

Yours,
Linus Walleij
