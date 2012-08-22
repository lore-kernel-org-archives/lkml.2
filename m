Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab2HVOmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:42:21 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:2463 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab2HVOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:42:19 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336348800"; 
   d="scan'208";a="14128934"
Date: Wed, 22 Aug 2012 15:41:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Q:pt_base in COMPAT mode offset by two pages. Was:Re: [Xen-devel]
 [PATCH 02/11] xen/x86: Use memblock_reserve for sensitive areas.
In-Reply-To: <503504FE0200007800096F08@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.02.1208221540570.15568@kaball.uk.xensource.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com> <1345133009-21941-3-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1208171835010.15568@kaball.uk.xensource.com> <20120820141305.GA2713@phenom.dumpdata.com>
 <20120821172732.GA23715@phenom.dumpdata.com> <20120821190317.GA13035@phenom.dumpdata.com> <503504FE0200007800096F08@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Jan Beulich wrote:
> >> The toolstack works fine - so launching 32-bit guests either
> >> under a 32-bit hypervisor or 64-bit works fine:
> >> ] domainbuilder: detail: xc_dom_alloc_segment:   page tables  : 0xcf805000 -> 
> > 0xcf885000  (pfn 0xf805 + 0x80 pages)
> >> [    0.000000] PT: cf805000 (f805000)
> >> 
> > 
> > And this patch on top of the others fixes this..
> 
> I didn't look at this in too close detail, but I started to get
> afraid that you might be making the code dependent on
> many hypervisor implementation details. And should the
> above turn out to be a bug in the hypervisor, I hope your
> kernel side changes won't make it impossible to fix that bug.

I agree
