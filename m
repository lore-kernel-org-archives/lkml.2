Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0E1I04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 04:26:56 -0400
Received: from www.tglx.de ([62.245.132.106]:36350 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab0E1I0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 04:26:53 -0400
Date: Fri, 28 May 2010 10:26:24 +0200 (CEST)
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
In-Reply-To: <Pine.LNX.4.44L0.1005271744130.3239-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.1005281024290.3116@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271744130.3239-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alan Stern wrote:

> On Thu, 27 May 2010, Thomas Gleixner wrote:
> 
> > > The two of you are talking at cross purposes.  Thomas is referring to 
> > > idle-based suspend and Matthew is talking about forced suspend.
> > 
> > Yes, and forced suspend to disk is the same as force suspend to disk,
> > which has both nothing to do with sensible resource management.
> 
> If I understand correctly, you are saying that all the untrusted 
> applications should run with QoS(NONE).  Then they could do whatever 
> they wanted without causing any interference.
> 
> And with idle-based power management (rather than forced suspend), 
> there would be no issue with wakeup events getting unduly delayed.
> 
> Unless one of those events was meant for an untrusted application.  Is 
> that the source of the difficulty?

Probably, but that's not solved by suspend blockers either as I
explained several times now. Because those untrusted apps either lack
blocker calls or are not allowed to use them, so the blocker does not
help for those either.

Thanks,

	tglx
