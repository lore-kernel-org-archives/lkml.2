Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0HQLdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 07:33:47 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:55928 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab0HQLdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 07:33:46 -0400
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
 take three
From: Igor Stoppa <igor.stoppa@nokia.com>
To: "ext Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Bottomley <James.Bottomley@suse.de>, "david@lang.hm" <david@lang.hm>,
        "Ted Ts'o" <tytso@mit.edu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swmike@swm.pp.se" <swmike@swm.pp.se>,
        "galibert@pobox.com" <galibert@pobox.com>,
        "florian@mickler.org" <florian@mickler.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "menage@google.com" <menage@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "arjan@infradead.org" <arjan@infradead.org>
In-Reply-To: <201008162311.27584.rjw@sisk.pl>
References: <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	 <20100813190801.GB26950@thunk.org>
	 <1281746599.16747.11.camel@mulgrave.site>  <201008162311.27584.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 15:07:07 +0300
Message-ID: <1282046827.13642.1119.camel@vimes.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Mon, 2010-08-16 at 23:11 +0200, ext Rafael J. Wysocki wrote:
> On Saturday, August 14, 2010, James Bottomley wrote:

<snip>

> > > The question, then, is whether a solution which addresses the only
> > > part of the problem which Rafael is interested in dealing with at this
> > > point, is sufficient such that (a) the kernel-level opportunistic
> > > suspend can be done as an out-of-tree patch, while simultaneously (b)
> > > allowing device drivers for Android devices can utilize Rafael's
> > > interfaces to solve the race design bug currently found in our suspend
> > > subsystem, while (c) requiring minimal changes to the Android
> > > userspace, and (d) providing all of the statistics and debugging
> > > functionality required by the Android userspace.
> > > 
> > > If we can engineer a solution which meets (a), (b), (c), and (d)
> > > above, then everyone will be happy.
> > 
> > That's my goal.
> 
> In fact, we (which means basically Alan Stern and me at this point) are working
> with Arve on this right now.

At least for (d) we - Nokia - would be also interested as well to
contribute, see [1].

In general it should help with keeping the solution more generic.

cheers, igor

[1]
https://lists.linux-foundation.org/pipermail/linux-pm/2010-August/028248.html

