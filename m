Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2HVOT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:19:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:47095 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2HVOTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:19:55 -0400
Date: Wed, 22 Aug 2012 16:19:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Attilio Rao <attilio.rao@citrix.com>, Ian.Campbell@citrix.com,
        Stefano.Stabellini@eu.citrix.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v2 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start
 and x86_init.paging.pagetable_setup_done setup functions and document its
 semantic
In-Reply-To: <20120822135753.GA30964@phenom.dumpdata.com>
Message-ID: <alpine.LFD.2.02.1208221618380.2856@ionos>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208212315330.2856@ionos> <20120822135753.GA30964@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Aug 21, 2012 at 11:22:03PM +0200, Thomas Gleixner wrote:
> > On Tue, 21 Aug 2012, Attilio Rao wrote:
> > > Differences with v1:
> > > - The patch serie is re-arranged in a way that it helps reviews, following
> > >   a plan by Thomas Gleixner
> > > - The PVOPS nomenclature is not used as it is not correct
> > > - The front-end message is adjusted with feedback by Thomas Gleixner,
> > >   Stefano Stabellini and Konrad Rzeszutek Wilk 
> > 
> > This is much simpler to read and review. Just have a look at the
> > diffstats of the two series:
> > 
> >  6 files changed,  9 insertions(+),  8 deletions(-)
> >  6 files changed, 11 insertions(+),  9 deletions(-)
> >  5 files changed, 50 insertions(+),  2 deletions(-)
> >  6 files changed,  2 insertions(+), 65 deletions(-)
> >  1 files changed,  5 insertions(+),  0 deletions(-)
> > 
> > versus
> > 
> >  6 files changed, 10 insertions(+),  9 deletions(-)
> >  6 files changed, 11 insertions(+), 11 deletions(-)
> >  5 files changed,  3 insertions(+),  3 deletions(-)
> >  6 files changed,  4 insertions(+), 20 deletions(-)
> >  1 files changed,  5 insertions(+),  0 deletions(-)
> > 
> > The overall result is basically the same, but it's way simpler to look
> > at obvious and well done patches than checking whether a subtle copy
> > and paste bug happened in 3/5 of the first version. Copy and paste is
> > the #1 cause for subtle bugs. :)
> > 
> > I'm waiting for the ack of Xen folks before taking it into tip.
> 
> I've some extra patches that modify the new "paginig_init" in the Xen
> code that I am going to propose for v3.7 - so will have some merge
> conflicts. Let me figure that out and also run this set of patches
> (and also the previous one .. which I think you didn't have a
> chance to look since you were on vacation?) on an overnight

Which previous one ?

> test to make sure there are no fallout.
> 
> With the merge issues that are going to prop up (x86 tip tree
> and my tree in linux-next) should I just take these patches
> in my tree with your Ack? Or should I just ingest your tiptree
> in my tree and that way solve the merge issue? What's your
> preference!

Having it in tip in an extra branch which you pull into your
tree. That's the easiest one.

Thanks,

	tglx
