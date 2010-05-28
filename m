Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab0E1Pam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:30:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37781 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757373Ab0E1Pak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:30:40 -0400
Date: Fri, 28 May 2010 11:30:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1275059924.27810.9640.camel@twins>
Message-ID: <Pine.LNX.4.44L0.1005281128280.1939-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Peter Zijlstra wrote:

> On Fri, 2010-05-28 at 10:35 -0400, Alan Stern wrote:
> >         The app is busy doing something else unimportant
> >         We do into power save
> >         Push a button, generate an IRQ
> >         Come out of power save
> >         No app to poke
> >         * System goes back to sleep and eventually wakes up again
> >         The app finishes what it was doing
> >         The app sees there is a keystroke and marks itself important
> >         ...
> > 
> > The * step is where trouble can occur. 
> 
> Only because you don't run runnable tasks. Please stop considering that
> an option and these problems go away.

True.  If the untrusted apps can be segregated and forcibly stopped, 
and if they don't need timely delivery of wakeup events, then there's 
no problem.

Alan Stern

