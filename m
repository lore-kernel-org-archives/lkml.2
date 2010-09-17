Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab0IQW1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:27:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab0IQW1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:27:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PM / Wakeup: Introduce wakeup source objects and event statistics (v2)
Date: Sat, 18 Sep 2010 00:26:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1009171000100.1589-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009171000100.1589-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009180026.37013.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 17, 2010, Alan Stern wrote:
> On Fri, 17 Sep 2010, Rafael J. Wysocki wrote:
> 
> > > Was doing some experiments with this on OMAP, and found a minor
> > > cut-and-paste bug in the Documentation file:
> > > 
> > > [...]
> > > 
> > > > +What:		/sys/devices/.../power/wakeup_max_time_ms
> > > > +Date:		September 2010
> > > > +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> > > > +Description:
> > > > +		The /sys/devices/.../wakeup_max_time_ms attribute contains
> > > > +		the maximum time of processing a single wakeup event associated
> > > > +		with the device, in milliseconds.  This attribute is read-only.
> > > > +		If the device is not enabled to wake up the system from sleep
> > > > +		states, this attribute is empty.
> > > > +
> > > > +What:		/sys/devices/.../power/wakeup_max_time_ms
> > >                                                       ^^^
> > > s/max/last/ for this one.
> > 
> > Ah, thanks a lot.
> 
> There was another copy & paste errors in that file, a 
> "wakeup_active_count" that should be "wakeup_hit_count".

Indeed, fixed now.

Thanks,
Rafael
