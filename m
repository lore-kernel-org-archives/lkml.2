Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0IXUuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:50:11 -0400
Received: from mail.wdtv.com ([66.118.69.84]:50163 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0IXUuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:50:09 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [00/80] 2.6.35.6 stable review
Date: Fri, 24 Sep 2010 16:49:57 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.6-rc1; KDE/4.5.1; i686; ; )
References: <20100924162706.GA7381@kroah.com>
In-Reply-To: <20100924162706.GA7381@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009241649.57150.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 24, 2010, Greg KH wrote:
>This is the start of the stable review cycle for the 2.6.35.6 release.
>There are 80 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let us know.  If anyone is a maintainer of the proper subsystem, and
>wants to add a Signed-off-by: line to the patch, please respond with it.
>
>Responses should be made by Sunday September 26, 17:00:00 UTC
>Anything received after that time might be too late.
>
>The whole patch series can be found in one patch at:
>	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.6-rc1.gz

Hi Greg;  I just pulled this about an hour ago, built it from a make 
oldconfig based on a flawlessly running 2.6.35.4.

3 things I call regressions.

1. On rebooting to it, and launching kmail, cpu went to 100% of whatever 
core it skipped to on a 4 core amd phenom box with 4G of ram.  Normally, 
kmail on a restart will check and rebuild its indices, taking maybe 4 or 5 
minutes to do this up till now, during that time keyboard/mouse 
interactivity lags a split second.  This time it was 44 minutes before I 
got my machine back.  At times the keyboard went dead for minutes at a 
time.  I even went to the kitchen and got fresh batteries for it, only to 
have everything I had typed blind 2 minutes before, show up on screen while 
there was no batteries in it.

2. That I think is separate from the login screen, there I had no keyboard 
or mouse for a minute, but something finally registered and I was able to 
log in then.

3. My usb tree is not fully populated, this has been a frequent problem for 
the last year or so, udev often does not wait for responses long enough to 
trace a several hubs tall tree to the last branch so I have to crawl under 
and unplug the missing stuff later, which is then properly recognized when I 
plug it back into the same socket on the same hub.  One of my often missing 
printers is 4 hubs away in the basement.

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
QOTD:
	Silence is the only virtue he has left.
