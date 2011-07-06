Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1GFUOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:14:15 -0400
Received: from lucidpixels.com ([72.73.18.11]:49031 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab1GFUOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:14:14 -0400
Date: Wed, 6 Jul 2011 16:14:13 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39.2: usb kernel panic/oops: schedule+ehci_irq+0x266/0x830
In-Reply-To: <Pine.LNX.4.44L0.1107061036190.1995-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.02.1107061611520.25497@p34.internal.lan>
References: <Pine.LNX.4.44L0.1107061036190.1995-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jul 2011, Alan Stern wrote:

> On Tue, 5 Jul 2011, Justin Piszcz wrote:
>
> You need to enable CONFIG_FRAME_POINTER; without that it is difficult
> to interpret the stack dump.  Also you should collect more than a
> single screen's worth of information, say by using a serial console or
> netconsole.
Done, I'll update when I have a new crash, thank you for the suggestion!

>> Is this a valid kernel bug?
>
> What's the difference between a "valid" kernel bug and an "invalid"
> kernel bug?  :-)
I was wondering if it could be HW related, even though I cannot seem to find
any HW fault.  Example, I attached 30+ USB devices as a test, R/W on all of
the flash and hard drives, no problems, this seems to occur spuriously when
little or no activity is occurring, hopefully w/FRAME POINTERS we will
get something useful next time.

>
> Yes, clearly it is a bug in the kernel.
>
>
> This could any of a number of things.  More information is needed.
>
> If the problem is easily reproducible, you can use git bisect to pin
> down the commit responsible for exposing the bug.
I wish it was, I tried above (30+ USB devices) no crash, its more or less
random, will wait for next crash and upadte then.

Thanks for the response.

Justin.

