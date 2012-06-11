Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2FKPhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:37:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab2FKPhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:37:41 -0400
Message-ID: <1339429021.24037.8.camel@bling.home>
Subject: Re: [PATCH v2 0/7] IOMMU: Groups support
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, bhelgaas@google.com,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com, liuj97@gmail.com
Date: Mon, 11 Jun 2012 09:37:01 -0600
In-Reply-To: <20120606110514.GG757@amd.com>
References: <20120530201424.31527.33142.stgit@bling.home>
	 <20120606110514.GG757@amd.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 13:05 +0200, Joerg Roedel wrote:
> On Wed, May 30, 2012 at 02:18:29PM -0600, Alex Williamson wrote:
> > v2:
> >  - Trickle down changes from pci_get_dma_source() to better handle
> >    PCI device reference counting in IOMMU driver patches
> 
> Okay, I looked again over the code and looks good for merging to me.

Great, thanks Joerg!

>  The
> IOMMU Groups code depends on changes in the PCI code. We need to work
> out how to merge this.
> 
> Bjorn,
> 
> I need the PCI changes before I can merge the IOMMU Groups code. There
> are two ways that would work for me:
> 
> 	a) You Ack the PCI patch-set from Alex and I put it into my tree
> 	   and merge the IOMMU Group code on-top, or
> 	b) You merge the PCI related patch-set into a seperate branch
> 	   which you can merge into your next-branch and which I can
> 	   pull in to merge IOMMU Groups on-top.
> 
> Please let me know what works best for you.

I also poked Bjorn with a minor v3 spin on his series, no change to this
series.

> What I would also appreciate are a few more Acks from other IOMMU
> maintainers (David W.?) and from the Power side.

Alexey, BenH, can either of you comment on this series from the POWER
side?  I know Alexey has an implementation of VFIO/Qemu device
assignment working on POWER with this series.  David Woodhouse, any
comments?  Thanks,

Alex

