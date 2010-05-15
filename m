Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0EOVUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:20:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50901 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755968Ab0EOVT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:19:56 -0400
Date: Sat, 15 May 2010 17:19:55 -0400 (EDT)
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
In-Reply-To: <AANLkTinwJdPneNSlAeTml5fHW2LFy53Dz3DRf95y1Bcl@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Brian Swetland wrote:

> In tickless mode, the time until next timer is a signed int, so the
> longest the kernel will ever sleep is ~2 seconds at a go.  In
> practice, userspace entities often have polling behavior that can
> trigger more often than that, and I've observed some kernel periodic
> timers (haven't cataloged them recently) that happen more often than
> once a second.

Paul and Kevin, how does the OMAP implementation handle these 
difficulties?

Also, how does it handle the issue of ill-behaved apps?

Alan Stern

