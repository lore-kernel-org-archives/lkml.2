Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab0E0V0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:26:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757174Ab0E0V0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:26:04 -0400
Date: Thu, 27 May 2010 17:26:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527203843.GA8395@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1005271724430.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:

> On Thu, May 27, 2010 at 10:23:50PM +0200, Thomas Gleixner wrote:
> > On Thu, 27 May 2010, Matthew Garrett wrote:
> > > A wakeup event is defined as one that wakes the system - if a system 
> > > can't be woken by a specific event then it's impossible to lose it, 
> > > since it wasn't a wakeup event to begin with.
> > 
> > So where is the problem ?
> 
> The problem is that, right now, if a wakeup event is received between 
> the point where userspace decides to start a suspend and userspace 
> actually starts a suspend, that event may not abort the suspend.

The two of you are talking at cross purposes.  Thomas is referring to 
idle-based suspend and Matthew is talking about forced suspend.

Or at least, that's how it appears to me.  No wonder you can't agree on 
anything.

Alan Stern

