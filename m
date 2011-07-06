Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1GFNqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:46:53 -0400
Received: from lucidpixels.com ([72.73.18.11]:45465 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab1GFNqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:46:51 -0400
Date: Wed, 6 Jul 2011 09:46:50 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-usb@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39.2: usb kernel panic/oops: schedule+ehci_irq+0x266/0x830
In-Reply-To: <alpine.DEB.2.02.1107060412440.27258@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1107060945470.8918@p34.internal.lan>
References: <alpine.DEB.2.02.1107051742290.3983@p34.internal.lan> <alpine.DEB.2.02.1107060412440.27258@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jul 2011, Justin Piszcz wrote:

>
>
> On Tue, 5 Jul 2011, Justin Piszcz wrote:
>
>> Hi,
>> 
>> I plan to build a new machine in the future (one with console access) but 
>> in the meantime, after my PSU replacement, the host is still having issues, 
>> I've turned off bluetooth wireless (built into the DP55KG) and will see if 
>> it panics again, link the latest panic/oops/etc:
>>

When it recurs, I will disable the 'threadirq' boot option with 2.6.39, as
that is when all this started happening and report back if it happens without
this option enabled.

Is there a reason why threadirq would cause weird issues on one HW type
chipset vs. another (both Intel)?

Justin.

