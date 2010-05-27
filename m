Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab0E0Vty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:49:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56498 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932723Ab0E0Vtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:49:52 -0400
Date: Thu, 27 May 2010 17:49:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <alpine.LFD.2.00.1005272332320.3478@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.1005271744130.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Thomas Gleixner wrote:

> > The two of you are talking at cross purposes.  Thomas is referring to 
> > idle-based suspend and Matthew is talking about forced suspend.
> 
> Yes, and forced suspend to disk is the same as force suspend to disk,
> which has both nothing to do with sensible resource management.

If I understand correctly, you are saying that all the untrusted 
applications should run with QoS(NONE).  Then they could do whatever 
they wanted without causing any interference.

And with idle-based power management (rather than forced suspend), 
there would be no issue with wakeup events getting unduly delayed.

Unless one of those events was meant for an untrusted application.  Is 
that the source of the difficulty?

Alan Stern

