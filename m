Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1EIHHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:07:22 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:40083 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1EIHHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:07:21 -0400
Date: Mon, 9 May 2011 09:06:59 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Daniel Kiper <dkiper@net-space.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/2] xen/mmu: Add workaround "x86-64, mm: Put early page table high"
Message-ID: <20110509070659.GA17552@router-fw-old.local.net-space.pl>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com> <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com> <20110503005527.GA6735@router-fw-old.local.net-space.pl> <20110503151206.GA8868@dumpdata.com> <20110503195141.GA15775@router-fw-old.local.net-space.pl> <20110504185903.GA29903@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105051133570.10886@kaball-desktop> <20110505140124.GD4386@dumpdata.com> <alpine.DEB.2.00.1105051504500.10886@kaball-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105051504500.10886@kaball-desktop>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 03:06:18PM +0100, Stefano Stabellini wrote:
> On Thu, 5 May 2011, Konrad Rzeszutek Wilk wrote:
> > > In any case you are right about the fact that the change is not needed
> > > on X86_32 so if it has any bad side effects on X86_32 we can always do
> >
> > Why not? Can't you boot a 32-bit Dom0 on those machines?
>
> Because e820_end_of_low_ram_pfn() is not called on 32-bit,
> find_low_pfn_range() is called instead and works differently.
> AFAICT find_low_pfn_range() is not affected by the issue described in
> the previous email.

Yes, you are right. Additionally, I tested your patch with my amendments ealier
and it works on i386. I am going to prepare relevant patch today or tomorrow.

Daniel
