Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0JTPMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:12:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47108 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0JTPMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:12:37 -0400
MIME-Version: 1.0
Message-ID: <5d143f14-26a1-4452-8b44-dae2a8b6df11@default>
Date: Wed, 20 Oct 2010 08:11:29 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@xensource.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
        linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [Xen-devel] Re: xen PV on HVM and initial domain merge in
 linux-next
References: <alpine.DEB.2.00.1010191254460.2423@kaball-desktop>
 <alpine.DEB.2.00.1010191847290.10348@kaball-desktop
 20101020113256.3647b1d9.sfr@canb.auug.org.au>
In-Reply-To: <20101020113256.3647b1d9.sfr@canb.auug.org.au>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not following the Xen develpment at all, I would like to have a
> positive reply from the listed Xen contacts, please,

I am not officially listed as a maintainer for Xen, but fwiw:

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

And, Stephen, I think Chris Wright and virtualization@lists.osdl.org
are stale entries in the MAINTAINERS file for Xen development,
so you are unlikely to receive replies from him/them.
(Chris, virtualization@lists.osdl.org ... please feel free
to correct me if I am wrong.)

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Tuesday, October 19, 2010 6:33 PM
> To: Stefano Stabellini
> Cc: xen-devel@lists.xensource.com; Jeremy Fitzhardinge; Konrad
> Rzeszutek Wilk; linux-kernel@vger.kernel.org; Chris Wright;
> virtualization@lists.osdl.org; linux-next@vger.kernel.org; Andrew
> Morton
> Subject: [Xen-devel] Re: xen PV on HVM and initial domain merge in
> linux-next
> 
> Hi Stefano,
> 
> [just casting the net a bit wider ...]
> 
> On Tue, 19 Oct 2010 18:51:47 +0100 Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> >
> > I forgot to CC the LKML and linux-next...
> >
> > On Tue, 19 Oct 2010, Stefano Stabellini wrote:
> > > Stephen,
> > > I have two patch series to merge in linux-next:
> > >
> > > PV on HVM: receive interrupts as xen events
> > > xen: initial domain support
> > >
> > > they have all the acked-by needed and are both stable since several
> > > weeks, however they depend on Konrad's xen-pcifront series and for
> this
> > > reason I waited until now to ask for a merge in linux-next.
> > >
> > > Could you please pull:
> > >
> > > git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git linux-
> next-initial-domain-v4
> > >
> > > it contains both series rebased on Konrad's pcifront series merged
> on
> > > linux-next (warning: it still contains the merge commit of
> > > xen-pcifront-0.8.2 in linux-next).
> > > Let me know if you have any conflicts or if you need me to change
> the
> > > branch somehow.
> 
> Not following the Xen develpment at all, I would like to have a
> positive
> reply from the listed Xen contacts, please,
> 
> I do have concerns that this is turning up so late, but I realise that
> that is mainly due to a misunderstanding on the part of some of the Xen
> community.
> 
> Also, the above tree is based on next-20101019 which means that I
> cannot
> use it as is.  All the trees merged into linux-next must be base on
> some
> other stable tree (almost always Linus' tree).  linux-next is rebuilt
> from scratch every day, so I cannot ever include a previous day's
> version.
> 
> Merging in other stable trees is OK (as long as the other maintainer is
> aware of that and makes sure that their tree does not reabse).
> 
> Basically what you send to me should be what you intend to send to
> Linus
> during the next merge window.
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
