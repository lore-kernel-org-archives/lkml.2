Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912Ab0HLTwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:52:50 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:58322 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754398Ab0HLTwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:52:46 -0400
Date: Thu, 12 Aug 2010 21:52:24 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Brian Swetland <swetland@google.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
        Theodore Tso <tytso@mit.edu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de,
        galibert@pobox.com, florian@mickler.org, menage@google.com,
        swmike@swm.pp.se, linux-pm@lists.linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, arjan@infradead.org
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
 take three
Message-ID: <20100812195224.GA6370@comet.dominikbrodowski.net>
Mail-Followup-To: Brian Swetland <swetland@google.com>,
	Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, peterz@infradead.org,
	linux-kernel@vger.kernel.org, James.Bottomley@suse.de,
	galibert@pobox.com, florian@mickler.org, menage@google.com,
	swmike@swm.pp.se, linux-pm@lists.linux-foundation.org,
	paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, arjan@infradead.org
References: <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
 <20100812010612.GL2516@linux.vnet.ibm.com>
 <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
 <20100812034435.GA7403@linux.vnet.ibm.com>
 <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
 <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
 <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
 <20100812174303.GD2524@linux.vnet.ibm.com>
 <AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
 <AANLkTinNxZoMab=tG9KXJ9n_nxB1dXHkfk-7xUMWXACW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinNxZoMab=tG9KXJ9n_nxB1dXHkfk-7xUMWXACW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:48:48PM -0700, Brian Swetland wrote:
> On Thu, Aug 12, 2010 at 12:34 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
> >
> > Not Ubuntu, not Fedora, not MeeGo, not anyone with a typical
> > user-space seems to be having this problem. I can argue to you that
> > this problem can be solved in easier ways, but instead I will argue
> > that perhaps we should wait for somebody besides Android to complain
> > about it before providing a "solution". Because after all, what good
> > is a "solution" provided by the kernel, if the user-space is not going
> > to use it, ever.
> 
> I'm curious, when does Android count as a user of the kernel?  I
> gather that volume of sales or users doesn't count.  Do we have to
> include some percentage of "desktop" Linux?
> 
> If we're an undesirable second-class citizen, why do people care that
> "android is forking the kernel"?
> 
> I guess I don't understand,

I guess I don't, either -- there are some parts of the kernel used by only a
handful of users... and here we speak about million users...

Best,
	Dominik
