Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2IKMzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 08:55:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49535 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2IKMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 08:55:03 -0400
Date: Tue, 11 Sep 2012 08:43:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Attilio Rao <attilio.rao@citrix.com>, Ian.Campbell@citrix.com,
        Stefano.Stabellini@eu.citrix.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v2 0/5] X86/XEN: Merge
 x86_init.paging.pagetable_setup_start and
 x86_init.paging.pagetable_setup_done setup functions and document its
 semantic
Message-ID: <20120911124359.GA5459@phenom.dumpdata.com>
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com>
 <alpine.LFD.2.02.1208212315330.2856@ionos>
 <20120822135753.GA30964@phenom.dumpdata.com>
 <alpine.LFD.2.02.1208221618380.2856@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208221618380.2856@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The overall result is basically the same, but it's way simpler to look
> > > at obvious and well done patches than checking whether a subtle copy
> > > and paste bug happened in 3/5 of the first version. Copy and paste is
> > > the #1 cause for subtle bugs. :)
> > > 
> > > I'm waiting for the ack of Xen folks before taking it into tip.

In case you are waiting for that - Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > I've some extra patches that modify the new "paginig_init" in the Xen
> > code that I am going to propose for v3.7 - so will have some merge
> > conflicts. Let me figure that out and also run this set of patches
> > (and also the previous one .. which I think you didn't have a
> > chance to look since you were on vacation?) on an overnight
> 
> Which previous one ?
> 
> > test to make sure there are no fallout.
> > 
> > With the merge issues that are going to prop up (x86 tip tree
> > and my tree in linux-next) should I just take these patches
> > in my tree with your Ack? Or should I just ingest your tiptree
> > in my tree and that way solve the merge issue? What's your
> > preference!
> 
> Having it in tip in an extra branch which you pull into your
> tree. That's the easiest one.

ping? Which branch should I pull?
> 
> Thanks,
> 
> 	tglx
