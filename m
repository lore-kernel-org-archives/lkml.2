Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0IBWTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:19:51 -0400
Received: from lucidpixels.com ([75.144.35.66]:43601 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab0IBWTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:19:50 -0400
Date: Thu, 2 Sep 2010 18:19:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: adam radford <aradford@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
In-Reply-To: <alpine.DEB.2.00.1009021025190.16817@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1009021818040.3149@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan> <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com> <alpine.DEB.2.00.1008271306100.24692@p34.internal.lan> <alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
 <alpine.DEB.2.00.1008310717260.4858@p34.internal.lan> <alpine.DEB.2.00.1008310732120.5156@p34.internal.lan> <alpine.DEB.2.00.1008310820350.19249@p34.internal.lan> <alpine.DEB.2.00.1009010536070.14332@p34.internal.lan> <AANLkTi=SO1nZbFySAs8_+TmCZcKBPihN6xrZfJihBnXG@mail.gmail.com>
 <alpine.DEB.2.00.1009020540500.22317@p34.internal.lan> <alpine.DEB.2.00.1009021025190.16817@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Sep 2010, Justin Piszcz wrote:

>
>
> On Thu, 2 Sep 2010, Justin Piszcz wrote:
>
>> 
>> 
>> On Wed, 1 Sep 2010, adam radford wrote:
>> 
>>> On Wed, Sep 1, 2010 at 2:40 AM, Justin Piszcz <jpiszcz@lucidpixels.com> 
>>> wrote:
>>> 
>>>> Could the lock/unlock be causing the issue?
>>>> Again, in 2.6.34, there are no latency problems or controller resets.
>>> 
>>> Justin,
>>> 
>>> We are looking into this issue and should get back to you soon.
>>> 
>>> The lock/unlock() kernel calls were not added by me but were part of a
>>> series of 'BKL pushdown' patches added by someone to all drivers with
>>> an ioctl interface.  If you think those might be related to your
>>> issue, you could try
>>> removing those 2 lines of code and recompiling.
>>> 
>>> If you haven't already, please email you kernel .config files for both
>>> the working kernel and non working kernel to the 3ware/LSI support
>>> people you are in contact with.
>>> 
>>> Thanks.
>>> 
>>> -Adam
>>> 
>> 
>
> I spoke too fast, it also happens with the 2.6.34 driver under 2.6.35.
> I will have to research this more, until then I'll stick with 2.6.34.
>
> Justin.
>
>

Adam/all,

Any recommendations on how to capture the freezing between the two kernels?
Which debug method would be best?
Does anyone else experience high wait times under 2.6.35 that uses 3ware cards?

I tested under another host with 2.6.35 (software raid only) and it did not
have any issues..

Justin.

