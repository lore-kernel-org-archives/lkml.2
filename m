Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0HGOg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 10:36:27 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56225 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab0HGOgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 10:36:25 -0400
Date: Sat, 7 Aug 2010 07:36:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: david@lang.hm, Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100807143620.GB19600@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
 <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
 <20100806123047.GE31326@sirena.org.uk>
 <20100806172226.GH2432@linux.vnet.ibm.com>
 <20100806173325.GA25367@rakim.wolfsonmicro.main>
 <20100806181832.GJ2432@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008061517130.30564@asgard.lang.hm>
 <20100807001431.GA3252@opensource.wolfsonmicro.com>
 <20100807003642.GQ2432@linux.vnet.ibm.com>
 <20100807130718.GC11817@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807130718.GC11817@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 02:07:18PM +0100, Mark Brown wrote:
> On Fri, Aug 06, 2010 at 05:36:42PM -0700, Paul E. McKenney wrote:
> > On Sat, Aug 07, 2010 at 01:14:32AM +0100, Mark Brown wrote:
> 
> > > services in themselves (like system monitoring).  It's really just
> > > semantics to treat them differently to something like a cellular modem -
> > > at a high level they're both just independant processors ticking away
> > > without the application processor.
> 
> > I agree that a smartphone's cellular modem can be argued to be very
> > similar to wake-on-LAN.  The smartphone applications that seem to me
> > to be very different from wake-on-LAN are things like audio playback,
> > where the system is providing service to the user during the time that
> > it is suspended.
> 
> The cellular modem case includes not just hanging off the network but
> also being on a call - the voice path for a phone call doesn't need the
> CPU to do anything.  It's probably best to view a phone as a bunch of
> interconnected systems that happen to sit in the same box, and there's
> various design decisions that can be taken about which systems own the
> shared components.

OK, apologies, I thought you were talking about the wait-for-a-call case.
If there actually is a call ongoing, then the user perceives the system as
doing something, so this is similar to audio playback and quite different
from wake-on-LAN or system monitoring.

							Thanx, Paul
