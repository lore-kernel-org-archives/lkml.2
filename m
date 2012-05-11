Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2EKAis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:38:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48534 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2EKAir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:38:47 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-1a-4fac5f95fc5e
Message-id: <4FAC5F95.10004@samsung.com>
Date: Fri, 11 May 2012 09:38:45 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: broonie@opensource.wolfsonmicro.com, thomas.abraham@linaro.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: Re: [PATCH 0/2] mfd: MAX8997: Support irq domain for Maxim MAX8997
References: <1336647288-10858-1-git-send-email-cw00.choi@samsung.com>
 <20120510182015.GB17018@kroah.com> <4FAC5313.80909@samsung.com>
 <20120510235237.GA28601@kroah.com>
In-reply-to: <20120510235237.GA28601@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 08:52 AM, Greg KH wrote:

> On Fri, May 11, 2012 at 08:45:23AM +0900, Chanwoo Choi wrote:
>> On 05/11/2012 03:20 AM, Greg KH wrote:
>>
>>> On Thu, May 10, 2012 at 07:54:48PM +0900, Chanwoo Choi wrote:
>>>> 
>>>>
>>>> But, I posted following patchset related to MAX8997 driver.
>>>> This patchset support Extcon framework in extcon-max8997 driver to
>>>> control external connector instead of max8997-muic driver. So, first
>>>> patch add MAX8997 extcon driver(drivers/extcon/extcon-max8997.c) and
>>>> last patch remove old MAX8997 muic driver(drivers/misc/max8997-muic.c).
>>>> - https://lkml.org/lkml/2012/5/8/98
>>>>
>>>> This patchset was applied in below git repository of Greg Kroah-Hartman.
>>>> - http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=shortlog;h=refs/heads/driver-core-next
>>>>
>>>> I think that this patchset should be applied on the git repository
>>>> of Greg Kroah-Hartman to remove possible conflict issue when merged.
>>>
>>> That's fine with me, should the MFD maintainer have been copied on this
>>> to get his signed-off-by on it?
>>>
>>
>> I knew that first patch written by Thomas Abraham has been already
>> confirmed ack message from MFD maintainer(Samuel Ortiz
>> <sameo@linux.intel.com>). You can check it on first patch and below git
>> repository of Mark Brown.
> 
> Ok, but why didn't you cc: him and everyone else who acked and
> signed-off on that patch?
> 

it is my mistake. I should have added maintainer related to first patch
as you said.
I will resend this patchset to all of people related to it now.

>> The below patch has occurred build break, so it was reverted by Mark
>> Brown. And then I did post this patchset with bug fix.
>>
>> http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=98d8618af37728f6e18e84110ddb99987b47dd12
> 
> So does that mean this one is ok, but the older one isn't?
> 
> confused, what exactly should I do here?
> 


Sorry, I have not sufficient explanation about history of patchset.

The below was written by Thomas Abraham and it was applied on
regulator.git repository.
http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=98d8618af37728f6e18e84110ddb99987b47dd12

But, this patch had occurred build break, it was reported by Stephen
Rothwell when build max8997-muic driver(drivers/misc/max8997-muic.c) and
then this patch was reverted by Mark Brown. You can check reverted patch
on below patch.
http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=82b719b11fd750188c125078ad6a6c0d23219dfb

Then, I posted patchset ,which is based on patch written by Thomas Abraham,
to add support irq domain for Max MAX8997 interrupts with bug fix.

I had to modify max8997-muic driver to avoid build break, But previously
I added extcon-max8997 driver and remove old max8997-muic
driver(drivers/misc/max8997-muic.c).
https://lkml.org/lkml/2012/5/8/98

So, I suggested that this patchset should be applied on the git reposity
of Greg
to remove possible conflict issue when merged because old max8997-muic
driver(drivers/misc/max8997-muic.c) is existed on regulator.git of Mark
Brown.

I am so sorry about obscure explanation of patchset history.

Best Regards,
Chanwoo Choi







