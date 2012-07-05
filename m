Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2GEXfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:35:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52017 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2GEXfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:35:34 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-cb-4ff624c52117
Message-id: <4FF624C4.8070102@samsung.com>
Date: Fri, 06 Jul 2012 08:35:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: gregkh@linuxfoundation.org, thomas.abraham@linaro.org,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 0/2] mfd: MAX8997: Support irq domain for Maxim
 MAX8997
References: <1341187362-16298-1-git-send-email-cw00.choi@samsung.com>
 <20120705142046.GC18200@sortiz-mobl>
In-reply-to: <20120705142046.GC18200@sortiz-mobl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd2jKt/8Db7cFrW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ/69dZSo4z1Wx7tYC1gbG8xxdjBwcEgImEruWmXUxcgKZYhIX
	7q1n62Lk4hASmM4ocejcdyini0ni9NupjCBVvAJaEseWn2YGaWYRUJU4fdIOJMwGFN7/4gYb
	SFhUIELiVz8HRLWgxI/J91hAwiICGhJ7e2pAJjILXGKUeDjvGxNIXFggRGLO3nKQciGBHIm+
	tS9ZQWxOAUOJ72chljIL6Ejsb53GBmHLS2xe85Z5AqPALCQbZiEpm4WkbAEj8ypG0dSC5ILi
	pPRcI73ixNzi0rx0veT83E2M4NB7Jr2DcVWDxSFGAQ5GJR7eCuVv/kKsiWXFlbmHGCU4mJVE
	eHszvvoL8aYkVlalFuXHF5XmpBYfYpTmYFES5zXxBkoJpCeWpGanphakFsFkmTg4pRoYQ87x
	fMo1ED2zlqdCeHea7vYJ7p1Ps4R8P+yo6/i37KL/z4KcMDYhp9lbv/602LlUMXdb1q+yNmaO
	K54pj5e5HPjj5f2lODGOfZn5H6uS7nnX15xsPWIs79AQ/U3DZI2LdIFvRvDV2vyTqwMvut37
	k5f16/muhPKF2xu1zVtn312+u3aJxvtmJZbijERDLeai4kQA/WuUqDkCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 07/05/2012 11:20 PM, Samuel Ortiz wrote:

> Hi Chanwoo,
> 
> On Mon, Jul 02, 2012 at 09:02:42AM +0900, Chanwoo Choi wrote:
>> This patchset add support irq domain for Maxim MAX8997 interrupts.
>>
>> I have discussed about this patchset with Greg KH and received below reply.
>> So, I resend this patchset.
>> - https://lkml.org/lkml/2012/5/20/142
>>
>> This first patch is based on patch written by Thomas Abraham
>> (https://lkml.org/lkml/2012/4/18/145) but this patch had occurred
>> build break, it was reported by Stephen Rothwell and this patch was
>> reverted by Mark Brown. You can check reverted patch on below patch.
>> - http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=82b719b11fd750188c125078ad6a6c0d23219dfb
>> So I fix two bug which set max88997->irq_domain instead
>> of NULL pointer and correct wrong parameter.
>>
>> The second patch use irq domain for muic interrupt of extcon-max8997
>> instead of irq_base in platform data of MAX8997 driver.
>>
>> Chanwoo Choi (1):
>>   Extcon: MAX8997: Add support irq domain for MAX8997 muic
>>
>> Thomas Abraham (1):
>>   mfd: add irq domain support for max8997 interrupts
> Both patches applied to my for-next branch, thanks.
> 
> Cheers,
> Samuel.
> 

Thank you for your reply and applied it

Best Regards,
Chanwoo Choi
