Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2IKGf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:35:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55518 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab2IKGf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:35:27 -0400
X-AuditID: cbfee61b-b7f586d000007adc-99-504edbad9163
From: Jingoo Han <jg1.han@samsung.com>
To: "'Ryan Mallon'" <rmallon@gmail.com>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com>
 <504ED55F.9060701@gmail.com>
In-reply-to: <504ED55F.9060701@gmail.com>
Subject: Re: [PATCH] gpio: samsung: use pr_* instead of printk
Date: Tue, 11 Sep 2012 15:35:25 +0900
Message-id: <001401cd8fe7$a06c6c90$e14545b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2P4+LbDJdt4CdhQBaGWu2fJARDywAA4FxA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd21t/0CDH6+0LO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZG27vZizYyFGxZNU0lgbGu2xdjJwcEgImEjNev2WBsMUkLtxb
	DxTn4hASmM4o8e35K2YIZzaTxONrS1hBqtgE1CS+fDnMDmKLCKhK7Oz/zwpSxCywgFHi5OwX
	YAkhgRiJBz8eMYHYnAKaEp9OXAWLCwvYSSzZ1AdmswA1P9owA6iZg4NXwFbi6HWwMK+AoMSP
	yffALmIW0JJYv/M4E4QtL7F5zVtmkHIJAXWJR391IU4wkrg16Q4bRImIxL4X7xgnMArNQjJp
	FpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4EB+Jr2DcVWDxSFGAQ5G
	JR7eG9F+AUKsiWXFlbmHGCU4mJVEeP1mAYV4UxIrq1KL8uOLSnNSiw8xSnOwKInzOp2zCxAS
	SE8sSc1OTS1ILYLJMnFwSjUw1mjWJ3O4MFUd/L8v85PctVVG4T8nXbuyMnnJ2m9bHx/aH3pF
	Zh8X542DJy78cmfvZFlq29ryN7eky1NN01UqrsaySNTewCFdo/KC4p+Gkq9ztd0YFszcz/Lo
	5R+rCXWhz2obFgRdPG3Wbtmf5eqvy5mwbOVWr7eNAiYLdFuDrx0sEmCacYtNiaU4I9FQi7mo
	OBEAR0ZGo2ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 11, 2012 3:09 PM Ryan Mallon wrote
> 
> On 10/09/12 21:59, Jingoo Han wrote:
> > This patch uses pr_* instead of printk.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com> ---
> > drivers/gpio/gpio-samsung.c |    6 +++--- 1 files changed, 3
> > insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-samsung.c
> > b/drivers/gpio/gpio-samsung.c index ba126cc..e38d990 100644 ---
> > a/drivers/gpio/gpio-samsung.c +++ b/drivers/gpio/gpio-samsung.c @@
> > -45,7 +45,7 @@ #ifndef DEBUG_GPIO #define gpio_dbg(x...) do { } while
> > (0) #else -#define gpio_dbg(x...) printk(KERN_DEBUG x) +#define
> > gpio_dbg(x...) pr_debug(x)
> 
> This is a functional change since pr_debug compiles away to nothing
> unless DEBUG is defined, so now you need to define both DEBUG and
> DEBUG_GPIO for this to print.
> 
> A better fix would be to just replace calls to gpio_dbg with pr_debug.
> 
> ~Ryan

Hi Ryan Mallon,

OK, I will replace gpio_dbg with pr_debug as you mentioned.
Thank you.

Best regards,
Jingoo Han


