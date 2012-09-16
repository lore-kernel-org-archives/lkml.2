Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2IPXas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 19:30:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50886 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2IPXaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 19:30:46 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-de-505661242352
Message-id: <50566124.2020303@samsung.com>
Date: Mon, 17 Sep 2012 08:30:44 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: MAX77693: Fix bug
References: <1345529747-24808-1-git-send-email-cw00.choi@samsung.com>
 <20120915223214.GF3647@sortiz-mobl>
In-reply-to: <20120915223214.GF3647@sortiz-mobl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQV3VxLAAg8V/2Cwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG6mlZBa/YK+4vP8ncwDiVrYuRk0NCwETi59wuKFtM4sK99UA2
	F4eQwHRGifl3/kI5XUwSWxa2glXxCmhJTJi+kgXEZhFQlTg35xkjiM0GFN//4gZQDQeHqECE
	xK9+DohyQYkfk++xgIRFBDQk9vbUgISZBYol+tqXMYPYwgL6EpNOPAKbKCSQLdH+8CqYzSlg
	IPFv5SlmiHodif2t09ggbHmJzWveMk9gFJiFZMMsJGWzkJQtYGRexSiaWpBcUJyUnmukV5yY
	W1yal66XnJ+7iREcfM+kdzCuarA4xCjAwajEwxtgHhogxJpYVlyZe4hRgoNZSYT3V2RYgBBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXFe4U+BAUIC6YklqdmpqQWpRTBZJg5OqQbGhT+9bDIt79qc
	2xWjz/Ej4fGG3gvPObJXblmi7rTkh9rrny/+Fn7aUWFvPumYrP3lG/vvzvHjEL9dPltzqjBD
	sf3j1pd/c9VjdBfusPof1/egvqLU1ybxw8sfkjz/UlNWrko64Xgx5/9GP5GCKaKf1+x9mOjc
	sS7hVZlIeknFVQ4n3n2Xt9SWKrEUZyQaajEXFScCABKdM+s6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2012 07:32 AM, Samuel Ortiz wrote:

> Hi Chanwoo,
> 
> On Tue, Aug 21, 2012 at 03:15:47PM +0900, Chanwoo Choi wrote:
>> This patchset fix bug of Maxim MAX77693 chip. First patch unmask interrupt
>> masking bit for charger/flas/muic device of Maxim MAX77693 and second patch
>> remove NULL pointer error when mfd-max77693 driver initialize irqs of Maxim
>> MAX77693 devices.
>>
>> Chanwoo Choi (2):
>>   mfd: MAX77693: Fix bug of interrupt handlding for MAX77693 devices
>>   mfd: MAX77693: Fix NULL pointer error when initialize irqs of Maxim
>>     MAX77693
>>
>>  drivers/extcon/extcon-max77693.c |   20 +++++++++++++-------
>>  drivers/mfd/max77693-irq.c       |   36 +++++++++++++++++++++++++++++++-----
>>  drivers/mfd/max77693.c           |   14 ++++++++++++++
>>  3 files changed, 58 insertions(+), 12 deletions(-)
> Both patches applied to my for-linus branch.
> 
> Cheers,
> Samuel.
> 


Thanks for your reply and applied it.

Best Regards,
Chanwoo Choi
