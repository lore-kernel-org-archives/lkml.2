Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab1DZVx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:53:59 -0400
Received: from lucidpixels.com ([75.144.35.66]:56984 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab1DZVx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:53:58 -0400
Date: Tue, 26 Apr 2011 17:53:57 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Roland Dreier <roland@kernel.org>
cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
In-Reply-To: <alpine.DEB.2.02.1104260619420.8361@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1104261753210.3894@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan> <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com> <alpine.DEB.2.02.1104260619420.8361@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Apr 2011, Justin Piszcz wrote:

>
>
> On Mon, 25 Apr 2011, Roland Dreier wrote:
>
>> On Mon, Apr 25, 2011 at 11:35 AM, Justin Piszcz <jpiszcz@lucidpixels.com> 
>> wrote:
>>> I notice periodic kernel crashes when using wireless.
>>> Has anyone seen this using the rt2800usb driver?
>>> 
>>> When the host is on the LAN (supermicro+intel), there are zero crashes.
>>> Since I don't have it in a location where I can use netdump over the
>>> LAN/wire, see the picture below for the kernel crash/OOPS on the console:
>>> 
>>> http://home.comcast.net/~jpiszcz/20110425/kernel_crash.jpg [1.2m]
>> 
>> Unfortunately a lot of the crash has scrolled away.  Is there any way
>> you can change your console's text mode to, say, 50 lines so more info
>> is visible?
>> 
>
> Hi,
>
> It crashed again:
> http://home.comcast.net/~jpiszcz/20110426/rt2800usb-crash2.jpg [1.1m]
>
> Please let me know if this is enough output as I cannot increase the
> resolution anymore on this monitor..  Also if you have any patches you would
> like me to try, let me know as this seems to happen quite often, thanks!
>
> Justin.
>
>
>

Hi,

I am trying a different driver now: rt2870sta
I've read a few reports this may be the 'proper' one to use.
So far so good, no lag or anything and I did not have to set power off
either.

Justin.
