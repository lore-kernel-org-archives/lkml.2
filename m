Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0EFTZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:25:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53056 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab0EFTZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:25:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Thu, 6 May 2010 21:26:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Brian Swetland <swetland@google.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Matthew Garrett <mjg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
References: <Pine.LNX.4.44L0.1005061007050.1708-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005061007050.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005062126.22909.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 May 2010, Alan Stern wrote:
> On Wed, 5 May 2010, Brian Swetland wrote:
> 
> > > Probably generalizing these into the LDM is the direction to go so
> > > userspace can set constraints on a per-device (or per-class?) basis:
> > >
> > > /sys/devices/.../power/constraint/throughput
> > > /sys/devices/.../power/constraint/wakeup_latency
> > > /sys/devices/.../power/constraint/... ?
> > 
> > The constraint stuff is definitely something I'd love to talk about in
> > detail.  It's a problem that I think is common to every SoC I've
> > worked with.  Having a general solution for this problem (of
> > specifying and observing various constraints for clock, power, qos,
> > etc) kernel-wide would seem like a big win.
> > 
> > Might be worth kicking some design ideas around and getting a bunch of
> > the interested parties together at some of the upcoming linux
> > conference things this fall on the east coast?
> 
> The Linux Power-Management Summit is scheduled for August 9, at the 
> start of the LinuxCon meeting in Boston.  This would make an excellent 
> topic for discussion.

Agreed.

Rafael
