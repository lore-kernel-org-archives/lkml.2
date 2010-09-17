Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0IQODO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:03:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38612 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753315Ab0IQODL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:03:11 -0400
Date: Fri, 17 Sep 2010 10:03:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: PM / Wakeup: Introduce wakeup source objects and event statistics
 (v2)
In-Reply-To: <201009170254.19753.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1009171000100.1589-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010, Rafael J. Wysocki wrote:

> > Was doing some experiments with this on OMAP, and found a minor
> > cut-and-paste bug in the Documentation file:
> > 
> > [...]
> > 
> > > +What:		/sys/devices/.../power/wakeup_max_time_ms
> > > +Date:		September 2010
> > > +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> > > +Description:
> > > +		The /sys/devices/.../wakeup_max_time_ms attribute contains
> > > +		the maximum time of processing a single wakeup event associated
> > > +		with the device, in milliseconds.  This attribute is read-only.
> > > +		If the device is not enabled to wake up the system from sleep
> > > +		states, this attribute is empty.
> > > +
> > > +What:		/sys/devices/.../power/wakeup_max_time_ms
> >                                                       ^^^
> > s/max/last/ for this one.
> 
> Ah, thanks a lot.

There was another copy & paste errors in that file, a 
"wakeup_active_count" that should be "wakeup_hit_count".

Alan Stern

