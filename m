Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab0E0RE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:04:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59385 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758092Ab0E0REZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:04:25 -0400
Date: Thu, 27 May 2010 13:04:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <felipe.balbi@nokia.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527162740.GA9625@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Felipe Balbi wrote:

> On Thu, May 27, 2010 at 05:06:23PM +0200, ext Alan Stern wrote:
> >If people don't mind, here is a greatly simplified summary of the
> >comments and objections I have seen so far on this thread:
> >
> >	The in-kernel suspend blocker implementation is okay, even
> >	beneficial.
> 
> I disagree here. I believe expressing that as QoS is much better. Let 
> the kernel decide which power state is better as long as I can say I 
> need 100us IRQ latency or 100ms wakeup latency.

Does this mean you believe "echo mem >/sys/power/state" is bad and
should be removed?  Or "echo disk >/sys/power/state"?  They pay no
attention to latencies or other requirements.

Alan Stern

