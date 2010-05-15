Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0EOC6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 22:58:53 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34880 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752258Ab0EOC6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 22:58:50 -0400
Date: Fri, 14 May 2010 22:58:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Brian Swetland <swetland@google.com>
cc: Kevin Hilman <khilman@deeprootsystems.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Lindgren <tony@atomide.com>,
       Matthew Garrett <mjg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       <magnus.damm@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       =?UTF-8?Q?Beno=C3=AEt_Cousson?= <b-cousson@ti.com>,
       <linux-omap@vger.kernel.org>, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <AANLkTil-Ky5L84JF7xn6su8VMtglBpZwCNIh7VgBiHgL@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005142256070.11498-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Brian Swetland wrote:

> It provides useful functionality -- you apparently disagree, but the
> wakelock/suspendblock model is in use, shipping, and solving problems
> for quite a lot of android devices that have been shipping for a while
> now.  We actively go to lowest power state in idle (on omap, msm,
> etc), and use drivers that aggressively declock and depower modules
> (similar to runtime pm), but we have found that using the
> opportunistic suspend model combined with wakelocks allows us to
> attain even lower average power consumption in always-connected,
> actively-syncing devices.

Can you explain this in more detail?  Are you saying that some devices
go on generating interrupts and causing timers to be scheduled, even 
though what they're doing isn't important enough to prevent the system 
from powering down?

Alan Stern

