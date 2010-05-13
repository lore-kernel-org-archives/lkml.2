Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0EMVNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:13:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54415 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab0EMVNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:13:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Thu, 13 May 2010 23:14:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, Matthew Garrett <mjg@redhat.com>,
       =?iso-8859-1?q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com> <Pine.LNX.4.44L0.1005131002380.1695-100000@iolanthe.rowland.org> <20100513191717.GA3428@atomide.com>
In-Reply-To: <20100513191717.GA3428@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005132314.22497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 May 2010, Tony Lindgren wrote:
> * Alan Stern <stern@rowland.harvard.edu> [100513 07:11]:
> > On Wed, 12 May 2010, Paul Walmsley wrote:
> > 
> > > Hello,
> > > 
> > > Some general comments on the suspend blockers/wakelock/opportunistic
> > > suspend v6 patch series, posted here:
> > > 
> > >     https://lists.linux-foundation.org/pipermail/linux-pm/2010-April/025146.html
> > > 
> > > The comments below are somewhat telegraphic in the interests of 
> > > readability - more specific comments to follow in later E-mails. I am 
> > > indebted to those of us who discussed these issues at LPC last year and 
> > > ELC this year for several stimulating discussions.
> > > 
> > > There are several general problems with the design of opportunistic
> > > suspend and suspend-blocks.
> > > 
> > > 1. The opportunistic suspend code bypasses existing Linux kernel code,
> > >    such as timers and the scheduler, that indicates when code
> > >    needs to run, and when the system is idle.
> > 
> > Whoa!  That's not my understanding at all.
> > 
> > As I see it, opportunistic suspend doesn't bypass any code that isn't 
> > already bypassed by the existing suspend code.  Users can do
> > 
> > 	echo mem >/sys/power/state
> > 
> > whenever they want, without regard to kernel timers and the scheduler 
> > (other than the fact that the user's thread must be running in order to 
> > carry out the write, of course).
> 
> The difference between echo mem > /sys/power/state and suspend blocks
> is that with suspend blocks the system keeps running.

Care to elaborate?

Rafael
