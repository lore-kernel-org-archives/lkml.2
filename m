Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1DYU5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:57:06 -0400
Received: from lucidpixels.com ([75.144.35.66]:50216 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386Ab1DYU47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:56:59 -0400
Date: Mon, 25 Apr 2011 16:56:58 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Roland Dreier <roland@kernel.org>
cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
In-Reply-To: <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1104251655520.23304@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan> <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Apr 2011, Roland Dreier wrote:

> On Mon, Apr 25, 2011 at 11:35 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> I notice periodic kernel crashes when using wireless.
>> Has anyone seen this using the rt2800usb driver?
>>
>> When the host is on the LAN (supermicro+intel), there are zero crashes.
>> Since I don't have it in a location where I can use netdump over the
>> LAN/wire, see the picture below for the kernel crash/OOPS on the console:
>>
>> http://home.comcast.net/~jpiszcz/20110425/kernel_crash.jpg [1.2m]
>
> Unfortunately a lot of the crash has scrolled away.  Is there any way
> you can change your console's text mode to, say, 50 lines so more info
> is visible?
>

Hi,

I will try and fix / increase the resolution and wait for the next crash and
update this thread with a new image when it crashes again.

Thanks.

Justin.


