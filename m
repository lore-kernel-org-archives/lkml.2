Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab0E0Ro7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:44:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58506 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932898Ab0E0Ro5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:44:57 -0400
Date: Thu, 27 May 2010 13:44:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>, <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1274981680.27810.5636.camel@twins>
Message-ID: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Peter Zijlstra wrote:

> On Thu, 2010-05-27 at 18:31 +0100, Matthew Garrett wrote:
> 
> > Even if we could use suspend-via-deep-idle-state on PCs, 
> 
> ( see Alan Cox's argument on PCs )
> 
> > we still need to be able to enter suspend while the system isn't idle.
> 
> _WHY_!?

You close your laptop's lid and throw the machine into a backpack.  At 
that time you want it to suspend even though it may not be idle.

> We've been trying to tell you you don't need that.

And I'm trying to tell you that you do.

Alan Stern

