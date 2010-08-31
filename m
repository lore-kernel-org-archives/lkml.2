Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0HaMXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:23:19 -0400
Received: from lucidpixels.com ([75.144.35.66]:46084 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab0HaMXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:23:18 -0400
Date: Tue, 31 Aug 2010 08:23:16 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: adam radford <aradford@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
In-Reply-To: <alpine.DEB.2.00.1008310732120.5156@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan> <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com> <alpine.DEB.2.00.1008271306100.24692@p34.internal.lan> <alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
 <alpine.DEB.2.00.1008310717260.4858@p34.internal.lan> <alpine.DEB.2.00.1008310732120.5156@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Aug 2010, Justin Piszcz wrote:

>
>
> On Tue, 31 Aug 2010, Justin Piszcz wrote:
>
>> 
>> 
>> On Sun, 29 Aug 2010, Justin Piszcz wrote:
>> 
>>> On Fri, 27 Aug 2010, Justin Piszcz wrote:
>
> Per my earlier message, both cards were resetting, scsi0 and scsi1 under
> kernel 2.6.35(.x), with 2.6.34, the lag problem is gone and my machine is
> back to normal again.  It is unlikely that both cards would be at fault,
> in addition I spent several hours trying different things, removing the BBU
> modules for example, but always staying on the 2.6.35 kernel.
>
> I am now able to run rss2email (which ALWAYS caused the machine to lockup
> and freeze until one of the controllers reset) without any problems using
> 2.6.34.
>
> 2.6.34.1 = good
> 2.6.35.x = has 3ware bug
>
> There appears to be a bug in the commit for the 3w-9xxx updates.
>
> On 2.6.34 now and no problems so far, I am continuing to test.
>
> http://marc.info/?l=linux-kernel&m=127419418304483&w=2
>
> Adam Radford (2):
>      3ware maintainers update
>      3w-xxxx, 3w-9xxx: force 60 second timeout
>
>
> Justin.


Latest-- 2.6.34.x seems to fix the issue, no lag whatsoever, the system is
very responsive when running rss2email, again no lag, have run 10-15 tests
without a single incident.  I also re-enabled msi and put my optimization
script back in init.d, everything continues to work perfectly.

Will wait for Adam on what went wrong with the 2.6.35 3w-9xxx update.

Justin.

