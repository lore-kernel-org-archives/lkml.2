Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0HaAEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:04:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48528 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab0HaAEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:04:42 -0400
Date: Mon, 30 Aug 2010 17:04:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Brian Swetland <swetland@google.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100831000437.GS2420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100812034435.GA7403@linux.vnet.ibm.com>
 <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
 <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
 <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
 <20100812174303.GD2524@linux.vnet.ibm.com>
 <AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
 <AANLkTinNxZoMab=tG9KXJ9n_nxB1dXHkfk-7xUMWXACW@mail.gmail.com>
 <AANLkTin3H0o+WQocUYjUcPGRpkRqK9H2LJ0OwHXFNBdj@mail.gmail.com>
 <20100813144236.GB2511@linux.vnet.ibm.com>
 <20100828085135.GA2711@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100828085135.GA2711@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 10:51:35AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > You are *one* user of the kernel. Let's suppose Android wasn't using
> > > suspend-blockers, and there was another equally successful linux
> > > mobile platform, Foobingo, and they were using them, and they were the
> > > only ones interested on implementing them.
> > > 
> > > What does that change? Nothing. They still need to convince the
> > > community that what they are proposing to be merged is actually
> > > useful, and somebody will use it. If not, they can just keep the patch
> > > for themselves until they do. I don't see the big deal.
> > 
> > So the current users of the Linux kernel are the following?
> > 
> > o	GNU/Linux
> > o	Android
> > 
> > Do any other distributions or devices with unusual user-space layouts
> > qualify?
> 
> QTembedded distros are somehow similar to android (one big binary).
> 
> Then there's minor stuff, like webOS and Motorola A1200...

It does sounds like there is some variety, then.  Thank you for the info!

							Thanx, Paul
