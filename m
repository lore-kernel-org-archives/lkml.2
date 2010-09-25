Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0IYPQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 11:16:40 -0400
Received: from mail.wdtv.com ([66.118.69.84]:38373 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab0IYPQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 11:16:39 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [00/80] 2.6.35.6 stable review
Date: Sat, 25 Sep 2010 11:16:35 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.6-rc1; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100924162706.GA7381@kroah.com> <201009241649.57150.gene.heskett@gmail.com> <20100925150201.GA3964@kroah.com>
In-Reply-To: <20100925150201.GA3964@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009251116.35946.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 25, 2010, Greg KH wrote:
>On Fri, Sep 24, 2010 at 04:49:57PM -0400, Gene Heskett wrote:
>> On Friday, September 24, 2010, Greg KH wrote:
>> >This is the start of the stable review cycle for the 2.6.35.6 release.
>> >There are 80 patches in this series, all will be posted as a response
>> >to this one.  If anyone has any issues with these being applied,
>> >please let us know.  If anyone is a maintainer of the proper
>> >subsystem, and wants to add a Signed-off-by: line to the patch,
>> >please respond with it.
>> >
>> >Responses should be made by Sunday September 26, 17:00:00 UTC
>> >Anything received after that time might be too late.
>> >
>> >The whole patch series can be found in one patch at:
>> >	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.6-
rc1.gz
>> 
>> Hi Greg;  I just pulled this about an hour ago, built it from a make
>> oldconfig based on a flawlessly running 2.6.35.4.
>
>Please cc: me on messages, I don't read lkml as well as I should these
>days due to travel.
>
>> 3 things I call regressions.
>> 
>> 1. On rebooting to it, and launching kmail, cpu went to 100% of
>> whatever core it skipped to on a 4 core amd phenom box with 4G of ram.
>>  Normally, kmail on a restart will check and rebuild its indices,

The email corpus is around 7Gb.

>> taking maybe 4 or 5 minutes to do this up till now, during that time
>> keyboard/mouse interactivity lags a split second.  This time it was 44
>> minutes before I got my machine back.  At times the keyboard went dead
>> for minutes at a time.  I even went to the kitchen and got fresh
>> batteries for it, only to have everything I had typed blind 2 minutes
>> before, show up on screen while there was no batteries in it.
>
>Odd, can you try reverting the patch below to see if it makes things
>better?  I need to drop it as Jens said it might cause problems.  Let me
>know if that solves the problem or not please.

This evening I should be able to report.

>> 2. That I think is separate from the login screen, there I had no
>> keyboard or mouse for a minute, but something finally registered and I
>> was able to log in then.
>> 
>> 3. My usb tree is not fully populated, this has been a frequent problem
>> for the last year or so, udev often does not wait for responses long
>> enough to trace a several hubs tall tree to the last branch so I have
>> to crawl under and unplug the missing stuff later, which is then
>> properly recognized when I plug it back into the same socket on the
>> same hub.  One of my often missing printers is 4 hubs away in the
>> basement.
>
>These both sound like the same issue, you might want to work to resolve
>them.

I will give this patch a shot this evening, today's schedule is already 
shot, there's a sport show at Stonewall Jackson Lake & resort.

>Oh, and 4 hubs distance, that's pushing the limits of USB, one flaky
>cable and you are not going to have a working printer...
>
I may in fact have a flaky hub, the first one is a 7 port Alps brand and I've 
found it now has a bad port or 2.  Lightning is a bitch, scheduled for a 
replacement now that I know about it.

>thanks,
>
>greg k-h

Thanks Greg, I'll be in touch.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
In buying horses and taking a wife shut your eyes tight and commend
yourself to God.
