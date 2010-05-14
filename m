Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0ENVYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:24:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab0ENVYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:24:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Fri, 14 May 2010 23:25:07 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       magnus.damm@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       =?iso-8859-1?q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com> <201005132356.21355.rjw@sisk.pl> <878w7mgqse.fsf@deeprootsystems.com>
In-Reply-To: <878w7mgqse.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005142325.08061.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 May 2010, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Thursday 13 May 2010, Tony Lindgren wrote:
> >> * Rafael J. Wysocki <rjw@sisk.pl> [100513 14:16]:
> 
> [...]
> 
> >>  
> >> > It solves a practical issue that _at_ _the_ _moment_ cannot be solved
> >> > differently, while there's a growing number of out-of-tree drivers depending
> >> > on this framework.  We need those drivers in and because we don't have any
> >> > viable alternative at hand, we have no good reason to reject it.
> >> 
> >> Nothing is preventing merging the drivers can be merged without
> >> these calls.
> >
> > And yet, there _is_ a growing nuber of drivers that don't get merge because
> > of that.  That's _reality_.  Are you going to discuss with facts, or what?
> 
> It may be reality, but IMO, "preventing other drivers" isn't a good
> *technical* argument for merging a feature.  It feels like these "for
> the 'good' of the community" arguments are being used to trump the
> technical arguments.  Maybe we need to keep the separate.
> 
> Distros (especially embedded ones) have long had out of tree features
> that create barriers to getting other drivers upstream.  While it
> might be nice to see all those features upstream, no one has argued
> that they should get merged simply because they create a barrier.  Each
> feature should be merged on its own technical merit.

Well, this is very much like the selinux vs apparmour (& friends) issue.
One can argue we need only one of them, but in fact we're not worse off having
both in.

The feature is not technically unacceptable to me and since having it in
would potentially make it easier to merge quite a few drivers, I regard that as
a good enough argument for.  YMMV.

Thanks,
Rafael
