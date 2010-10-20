Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0JTPaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:30:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30288 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab0JTP36 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 20 Oct 2010 11:29:58 -0400
Date: Wed, 20 Oct 2010 11:28:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: xen PV on HVM and initial domain merge in linux-next
Message-ID: <20101020152808.GA22328@dumpdata.com>
References: <alpine.DEB.2.00.1010191254460.2423@kaball-desktop>
 <alpine.DEB.2.00.1010191847290.10348@kaball-desktop>
 <20101020113256.3647b1d9.sfr@canb.auug.org.au>
 <alpine.DEB.2.00.1010201455160.10348@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010201455160.10348@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 04:16:17PM +0100, Stefano Stabellini wrote:
> On Wed, 20 Oct 2010, Stephen Rothwell wrote:
> > Hi Stefano,
> > 
> > [just casting the net a bit wider ...]
> > 
> > On Tue, 19 Oct 2010 18:51:47 +0100 Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > >
> > > I forgot to CC the LKML and linux-next...
> > > 
> > > On Tue, 19 Oct 2010, Stefano Stabellini wrote:
> > > > Stephen,
> > > > I have two patch series to merge in linux-next:
> > > > 
> > > > PV on HVM: receive interrupts as xen events
> > > > xen: initial domain support
> > > > 
> > > > they have all the acked-by needed and are both stable since several
> > > > weeks, however they depend on Konrad's xen-pcifront series and for this
> > > > reason I waited until now to ask for a merge in linux-next.
> > > > 
> > > > Could you please pull:
> > > > 
> > > > git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git linux-next-initial-domain-v4
> > > > 
> > > > it contains both series rebased on Konrad's pcifront series merged on
> > > > linux-next (warning: it still contains the merge commit of
> > > > xen-pcifront-0.8.2 in linux-next).
> > > > Let me know if you have any conflicts or if you need me to change the
> > > > branch somehow.
> > 
> > Not following the Xen develpment at all, I would like to have a positive
> > reply from the listed Xen contacts, please,
> > 
> 
> Sure.
> Jeremy?

The patches touch the Xen PCI components, so:

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

And yeah, we need to update the MAINTAINERS file. Let me spin one out
with the folks who are currently involved in this.

> 
> 
> > I do have concerns that this is turning up so late, but I realise that
> > that is mainly due to a misunderstanding on the part of some of the Xen
> > community.
> > 
> 
> Thank you very much for understanding!
> 
> 
> > Also, the above tree is based on next-20101019 which means that I cannot
> > use it as is.  All the trees merged into linux-next must be base on some
> > other stable tree (almost always Linus' tree).  linux-next is rebuilt
> > from scratch every day, so I cannot ever include a previous day's version.
> > 
> > Merging in other stable trees is OK (as long as the other maintainer is
> > aware of that and makes sure that their tree does not reabse).
> > 
> > Basically what you send to me should be what you intend to send to Linus
> > during the next merge window.
>  
> All right.
> I merged Jeremy's and Konrad's branches (the ones you just merged on
> linux-next) on top of linux 2.6.36 rc8, then I rebased my series on top
> of the result.
> Please checkout this branch:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc8-initial-domain-v5

Just as a note, you might want to create a branch titled

#linux-next in your git tree and link the reviewed/acked/tested branch to it. That way
Stephen does not have to change his entries in the linux-next tree every release.

> 
> and let me know if it is suitable, it shouldn't have any merge
> conflicts.

/me nods. Works nicely. Thank you for doing this on such a short-time frame.
