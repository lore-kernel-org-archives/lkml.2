Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729Ab0HMOmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 10:42:47 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36034 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761717Ab0HMOmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 10:42:45 -0400
Date: Fri, 13 Aug 2010 07:42:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Brian Swetland <swetland@google.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100813144236.GB2511@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100812010612.GL2516@linux.vnet.ibm.com>
 <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
 <20100812034435.GA7403@linux.vnet.ibm.com>
 <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
 <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
 <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
 <20100812174303.GD2524@linux.vnet.ibm.com>
 <AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
 <AANLkTinNxZoMab=tG9KXJ9n_nxB1dXHkfk-7xUMWXACW@mail.gmail.com>
 <AANLkTin3H0o+WQocUYjUcPGRpkRqK9H2LJ0OwHXFNBdj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin3H0o+WQocUYjUcPGRpkRqK9H2LJ0OwHXFNBdj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 01:58:12PM +0300, Felipe Contreras wrote:
> On Thu, Aug 12, 2010 at 10:48 PM, Brian Swetland <swetland@google.com> wrote:
> > On Thu, Aug 12, 2010 at 12:34 PM, Felipe Contreras
> > <felipe.contreras@gmail.com> wrote:
> >>
> >> Not Ubuntu, not Fedora, not MeeGo, not anyone with a typical
> >> user-space seems to be having this problem. I can argue to you that
> >> this problem can be solved in easier ways, but instead I will argue
> >> that perhaps we should wait for somebody besides Android to complain
> >> about it before providing a "solution". Because after all, what good
> >> is a "solution" provided by the kernel, if the user-space is not going
> >> to use it, ever.
> >
> > I'm curious, when does Android count as a user of the kernel?  I
> > gather that volume of sales or users doesn't count.  Do we have to
> > include some percentage of "desktop" Linux?
> 
> You are *one* user of the kernel. Let's suppose Android wasn't using
> suspend-blockers, and there was another equally successful linux
> mobile platform, Foobingo, and they were using them, and they were the
> only ones interested on implementing them.
> 
> What does that change? Nothing. They still need to convince the
> community that what they are proposing to be merged is actually
> useful, and somebody will use it. If not, they can just keep the patch
> for themselves until they do. I don't see the big deal.

So the current users of the Linux kernel are the following?

o	GNU/Linux
o	Android

Do any other distributions or devices with unusual user-space layouts
qualify?

							Thanx, Paul

> > If we're an undesirable second-class citizen, why do people care that
> > "android is forking the kernel"?
> 
> Nobody has expressed anything remotely like that (that you are a
> second-class citizen). Why makes you think so? Lots of people get
> patches denied. Like Nokia's u_char driver, which is *way* less
> controversial than this one.
> 
> -- 
> Felipe Contreras
