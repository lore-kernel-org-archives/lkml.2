Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab0E0R6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:58:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55515 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753843Ab0E0R6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:58:36 -0400
Date: Thu, 27 May 2010 19:05:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527190515.08be091a@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527174019.GA3187@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<alpine.LFD.2.00.1005271915540.3032@localhost.localdomain>
	<20100527173118.GE2468@srcf.ucam.org>
	<1274981680.27810.5636.camel@twins>
	<20100527174019.GA3187@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 18:40:19 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 27, 2010 at 07:34:40PM +0200, Peter Zijlstra wrote:
> > > we still need to be able to enter suspend while the system isn't idle.
> > 
> > _WHY_!?
> 
> Because if I'm running a kernel build in a tmpfs and I hit the sleep 
> key, I need to go to sleep. Blocking processes on driver access isn't 
> sufficient.

Suspend as an idle state

Suspend as a 'hand of God' choice.

One is a performance optimisation the other is an operator executive
decision.

I'd prefer we avoided mixing them up. Everyone seems fairly happy with
the current operator ordered suspend behaviour I believe ?
