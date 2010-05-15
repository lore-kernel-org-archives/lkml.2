Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0EOCfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 22:35:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59238 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755112Ab0EOCfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 22:35:41 -0400
Date: Fri, 14 May 2010 22:35:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, <magnus.damm@gmail.com>,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, Matthew Garrett <mjg@redhat.com>,
       =?iso-8859-1?q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       <linux-omap@vger.kernel.org>, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <201005140028.49443.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1005142233070.11498-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Rafael J. Wysocki wrote:

> > > How do you handle situations where the CPU is currently idle but an 
> > > event (such as I/O completion) is expected to occur in the near future?  
> > > You don't want to power-off and reboot then, do you?
> > 
> > The idle code looks at next_timer_interrupt() value, then if the
> > next timer event if far enough ahead, the system powers down and
> > wakes to the timer interrupt. It also wakes to device interrupts.
> 
> For the record, waking to interrupts doesn't work on quite some systems
> (like ACPI-based PCs for one example).

Ironically, it appears that ACPI-based PCs are in a position to benefit 
more from opportunistic suspend and suspend blockers than are embedded 
systems -- and yet they are being proposed for use on cell phones 
rather than on desktops.

Alan Stern

