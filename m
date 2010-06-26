Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0FZT60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 15:58:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53652 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754016Ab0FZT6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 15:58:24 -0400
Date: Sat, 26 Jun 2010 15:58:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: David Brownell <david-b@pacbell.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       mark gross <640e9920@gmail.com>, Florian Mickler <florian@mickler.org>,
       Neil Brown <neilb@suse.de>, <linux-pci@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [linux-pm] [PATCH] PM: Make it possible to avoid wakeup events
 from being lost
In-Reply-To: <201006262021.42966.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1006261550400.24010-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010, Rafael J. Wysocki wrote:

> On Saturday, June 26, 2010, Alan Stern wrote:
> > On Sat, 26 Jun 2010, David Brownell wrote:
> ... 
> > > > +        The
> > > > /sys/power/wakeup_count file allows user space to avoid
> > > > +        losing wakeup events
> > > > when transitioning the system into a sleep
> > > > +        state.  Reading
> > 
> > This could have been phrased better:  The /sys/power/wakeup_count file
> > allows user space to put the system into a sleep state conditionally
> > subject to the arrival of concurrent wakeup events, which will either
> > block the sleep transition or cause it to fail.
> 
> I'll chage this in the final version.  Thanks!

Even this should be simplified, if possible.  Maybe something like: ...  
put the system into a sleep state while taking into account the
concurrent arrival of wakeup events ...

I tried to put the word "reliably" in there, but it didn't seem to fit.  
After all, the current /sys/power/state is already very reliable about 
putting the system to sleep!

Alan Stern

