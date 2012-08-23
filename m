Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030529Ab2HWOB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:01:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36345 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212Ab2HWOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:01:24 -0400
Date: Thu, 23 Aug 2012 09:50:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Attilio Rao <attilio.rao@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2 0/5] X86/XEN: Merge
 x86_init.paging.pagetable_setup_start and
 x86_init.paging.pagetable_setup_done setup functions and document its
 semantic
Message-ID: <20120823135051.GA10973@phenom.dumpdata.com>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
 <alpine.LFD.2.02.1208212315330.2856@ionos>
 <20120822135753.GA30964@phenom.dumpdata.com>
 <alpine.LFD.2.02.1208221618380.2856@ionos>
 <5034F0FD.8040902@citrix.com>
 <5035F7BD.6090205@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5035F7BD.6090205@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 10:28:29AM +0100, Attilio Rao wrote:
> On 22/08/12 15:47, Attilio Rao wrote:
> >On 22/08/12 15:19, Thomas Gleixner wrote:
> >>On Wed, 22 Aug 2012, Konrad Rzeszutek Wilk wrote:
> >>
> >>>On Tue, Aug 21, 2012 at 11:22:03PM +0200, Thomas Gleixner wrote:
> >>>
> >>>>On Tue, 21 Aug 2012, Attilio Rao wrote:
> >>>>
> >>>>>Differences with v1:
> >>>>>- The patch serie is re-arranged in a way that it helps reviews, following
> >>>>>    a plan by Thomas Gleixner
> >>>>>- The PVOPS nomenclature is not used as it is not correct
> >>>>>- The front-end message is adjusted with feedback by Thomas Gleixner,
> >>>>>    Stefano Stabellini and Konrad Rzeszutek Wilk
> >>>>>
> >>>>This is much simpler to read and review. Just have a look at the
> >>>>diffstats of the two series:
> >>>>
> >>>>   6 files changed,  9 insertions(+),  8 deletions(-)
> >>>>   6 files changed, 11 insertions(+),  9 deletions(-)
> >>>>   5 files changed, 50 insertions(+),  2 deletions(-)
> >>>>   6 files changed,  2 insertions(+), 65 deletions(-)
> >>>>   1 files changed,  5 insertions(+),  0 deletions(-)
> >>>>
> >>>>versus
> >>>>
> >>>>   6 files changed, 10 insertions(+),  9 deletions(-)
> >>>>   6 files changed, 11 insertions(+), 11 deletions(-)
> >>>>   5 files changed,  3 insertions(+),  3 deletions(-)
> >>>>   6 files changed,  4 insertions(+), 20 deletions(-)
> >>>>   1 files changed,  5 insertions(+),  0 deletions(-)
> >>>>
> >>>>The overall result is basically the same, but it's way simpler to look
> >>>>at obvious and well done patches than checking whether a subtle copy
> >>>>and paste bug happened in 3/5 of the first version. Copy and paste is
> >>>>the #1 cause for subtle bugs. :)
> >>>>
> >>>>I'm waiting for the ack of Xen folks before taking it into tip.

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
on all patches.

Please tell me which branch its going in so I can merge that one in my tree.
Thanks!
> >>>>
> >>>I've some extra patches that modify the new "paginig_init" in the Xen
> >>>code that I am going to propose for v3.7 - so will have some merge
> >>>conflicts. Let me figure that out and also run this set of patches
> >>>(and also the previous one .. which I think you didn't have a
> >>>chance to look since you were on vacation?) on an overnight
> >>>
> >>Which previous one ?
> >>
> >This one:
> >https://lkml.org/lkml/2012/8/21/369
> >
> >but I would like to repost the patch serie skipping the referral to
> >PVOPS in the commit logs, I will do so right now, so please wait for
> >another patch serie.
> 
> For your convenience:
> http://lkml.org/lkml/2012/8/22/450
> 
> Attilio
