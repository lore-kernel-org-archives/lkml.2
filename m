Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab0EFOIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:08:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56051 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754738Ab0EFOIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:08:14 -0400
Date: Thu, 6 May 2010 10:08:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Brian Swetland <swetland@google.com>
cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Matthew Garrett <mjg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, <magnus.damm@gmail.com>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <h2va55d774e1005051642m6159aadclfda9d1c77cb10cda@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005061007050.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Brian Swetland wrote:

> > Probably generalizing these into the LDM is the direction to go so
> > userspace can set constraints on a per-device (or per-class?) basis:
> >
> > /sys/devices/.../power/constraint/throughput
> > /sys/devices/.../power/constraint/wakeup_latency
> > /sys/devices/.../power/constraint/... ?
> 
> The constraint stuff is definitely something I'd love to talk about in
> detail.  It's a problem that I think is common to every SoC I've
> worked with.  Having a general solution for this problem (of
> specifying and observing various constraints for clock, power, qos,
> etc) kernel-wide would seem like a big win.
> 
> Might be worth kicking some design ideas around and getting a bunch of
> the interested parties together at some of the upcoming linux
> conference things this fall on the east coast?

The Linux Power-Management Summit is scheduled for August 9, at the 
start of the LinuxCon meeting in Boston.  This would make an excellent 
topic for discussion.

Alan Stern

