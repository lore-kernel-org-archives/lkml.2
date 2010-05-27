Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab0E0Ve3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:34:29 -0400
Received: from www.tglx.de ([62.245.132.106]:58059 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab0E0VeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:34:25 -0400
Date: Thu, 27 May 2010 23:33:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <Pine.LNX.4.44L0.1005271724430.3239-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.1005272332320.3478@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271724430.3239-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alan Stern wrote:

> On Thu, 27 May 2010, Matthew Garrett wrote:
> 
> > On Thu, May 27, 2010 at 10:23:50PM +0200, Thomas Gleixner wrote:
> > > On Thu, 27 May 2010, Matthew Garrett wrote:
> > > > A wakeup event is defined as one that wakes the system - if a system 
> > > > can't be woken by a specific event then it's impossible to lose it, 
> > > > since it wasn't a wakeup event to begin with.
> > > 
> > > So where is the problem ?
> > 
> > The problem is that, right now, if a wakeup event is received between 
> > the point where userspace decides to start a suspend and userspace 
> > actually starts a suspend, that event may not abort the suspend.
> 
> The two of you are talking at cross purposes.  Thomas is referring to 
> idle-based suspend and Matthew is talking about forced suspend.

Yes, and forced suspend to disk is the same as force suspend to disk,
which has both nothing to do with sensible resource management.

Thanks,

	tglx
