Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1GFOlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:41:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40900 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753304Ab1GFOli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:41:38 -0400
Date: Wed, 6 Jul 2011 10:41:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39.2: usb kernel panic/oops: schedule+ehci_irq+0x266/0x830
In-Reply-To: <alpine.DEB.2.02.1107060945470.8918@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1107061040510.1995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Justin Piszcz wrote:

> On Wed, 6 Jul 2011, Justin Piszcz wrote:
> 
> >
> >
> > On Tue, 5 Jul 2011, Justin Piszcz wrote:
> >
> >> Hi,
> >> 
> >> I plan to build a new machine in the future (one with console access) but 
> >> in the meantime, after my PSU replacement, the host is still having issues, 
> >> I've turned off bluetooth wireless (built into the DP55KG) and will see if 
> >> it panics again, link the latest panic/oops/etc:
> >>
> 
> When it recurs, I will disable the 'threadirq' boot option with 2.6.39, as
> that is when all this started happening and report back if it happens without
> this option enabled.
> 
> Is there a reason why threadirq would cause weird issues on one HW type
> chipset vs. another (both Intel)?

ehci-hcd doesn't use threaded interrupts, so in theory that option 
shouldn't make any difference.  Of course, theory isn't always right.

Alan Stern

