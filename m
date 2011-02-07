Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1BGP4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:56:15 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47726 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1BGP4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:56:14 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+fkN9maRmp9h7wXXHS36Q4
Date: Mon, 7 Feb 2011 07:55:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to
 setup.c
Message-ID: <20110207155532.GD20795@atomide.com>
References: <20110111104051.GA11039@n2100.arm.linux.org.uk>
 <20110111153630.GB2707@angua.secretlab.ca>
 <20110111154833.GF11039@n2100.arm.linux.org.uk>
 <AANLkTi=29LB66j123ufMHQk=46hGYdmR4nZZQFnN=Tku@mail.gmail.com>
 <20110112155215.GB11039@n2100.arm.linux.org.uk>
 <AANLkTinwGd9pa7YQ=5hXfarw=MB=YdpBuN7xJAd+Ps4f@mail.gmail.com>
 <alpine.LFD.2.00.1101121145430.24532@xanadu.home>
 <AANLkTinPibTVUu2zoMbDYnSWXGvB6dVjCp54DoN9S1p3@mail.gmail.com>
 <20110112172552.GF11039@n2100.arm.linux.org.uk>
 <AANLkTi=dNaOF0wxU+OYEKiWfoGeVKGnqvF3gK8-mQjo5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=dNaOF0wxU+OYEKiWfoGeVKGnqvF3gK8-mQjo5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [110112 09:48]:
> On Wed, Jan 12, 2011 at 10:25 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, Jan 12, 2011 at 10:16:44AM -0700, Grant Likely wrote:
> >> On Wed, Jan 12, 2011 at 9:53 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> >> > On Wed, 12 Jan 2011, Grant Likely wrote:
> >> >
> >> >> Actually it looks like the real problem is that the mmu has been
> >> >> turned on, but the virtual mappings for devices have not yet been
> >> >> established, and so the debug macros aren't using a valid address.
> >> >
> >> > A temporary virtual mapping should be there -- look for addruart in
> >> > head.S.
> >>
> >> Hi Russell and Nicolas,
> >>
> >> Oops, yes all the early debug stuff works fine.  Stupid human trick on
> >> my end, but I've sorted it out now.  Thanks for the help.  I'll have
> >> patches to post later today.
> >
> > I just hacked this up, and on Versatile (real hardware) it produces
> > the below for an invalid r1 value - and of course works for a proper r1
> > value.
> 
> Heh, that look pretty close to identical to what I was just about to send.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Tested-by: Tony Lindgren <tony@atomide.com>
