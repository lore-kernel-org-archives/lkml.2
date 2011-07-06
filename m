Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1GFUia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:38:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42929 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755980Ab1GFUi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:38:29 -0400
Date: Wed, 6 Jul 2011 16:38:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39.2: usb kernel panic/oops: schedule+ehci_irq+0x266/0x830
In-Reply-To: <alpine.DEB.2.02.1107061614140.25497@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1107061636130.1995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Justin Piszcz wrote:

> > ehci-hcd doesn't use threaded interrupts, so in theory that option
> > shouldn't make any difference.  Of course, theory isn't always right.
> >
> > Alan Stern
> >
> 
> Hi,
> 
> In that case I will leave it on w/ FRAME pointers enabled and we'll see 
> what happens.

Right.  It's always possible that the threaded IRQ code causes a bug
somewhere else in the kernel, and it just happens to show up
sporadically in ehci-hcd.  Having more information will help narrow 
this down.

Alan Stern

