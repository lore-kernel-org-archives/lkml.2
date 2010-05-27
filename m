Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0E0V0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:26:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48444 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932556Ab0E0V0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:26:48 -0400
Date: Thu, 27 May 2010 22:34:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527223418.281a687f@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1005271327560.3239-100000@iolanthe.rowland.org>
References: <1274980420.27810.5557.camel@twins>
	<Pine.LNX.4.44L0.1005271327560.3239-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 13:29:18 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 27 May 2010, Peter Zijlstra wrote:
> 
> > On Thu, 2010-05-27 at 13:04 -0400, Alan Stern wrote:
> > > 
> > > Does this mean you believe "echo mem >/sys/power/state" is bad and
> > > should be removed?  Or "echo disk >/sys/power/state"?  They pay no
> > > attention to latencies or other requirements. 
> > 
> > Those are a whole different beast, those are basically a quick-off
> > button like thing. Forced suspend is conceptually a very different beast
> > from power-saving a running system.
> 
> They may be different conceptually.  Nevertheless, Android uses forced 
> suspend as a form of power saving.  Until better mechanisms are in 
> place, it makes sense.

For them, not for Linux.

Several vendors have exciting kernel drivers that do things like binary
patch other modules. Until better mechanisms are in place it does *NOT*
make sense to merge such stuff.

I don't care what they do in their own tree (consenting adults in their
own home and all that) but what they do in the public tree is another
matter.

Alan
