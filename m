Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab2FFX6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab2FFX6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:58:37 -0400
Date: Wed, 6 Jun 2012 16:58:27 -0700
From: Chris Wright <chrisw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>, iommu@lists.linux-foundation.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 2/2] iommu: dmar -- reserve mmio space used by IOMMU
Message-ID: <20120606235827.GK12686@x200.localdomain>
References: <1338845342-12464-1-git-send-email-ddutile@redhat.com>
 <1338845342-12464-3-git-send-email-ddutile@redhat.com>
 <1338849430.10884.288.camel@shinybook.infradead.org>
 <4FCD401D.9000304@redhat.com>
 <1338852196.26785.10.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338852196.26785.10.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Mon, 2012-06-04 at 19:09 -0400, Don Dutile wrote:
> > How does the kernel probe for chipsets, then registers with the chipsets
> > to find the programmed IOMMU BAR values?
> > -- I missed that class.... I only have Intel Virt Tech Directed I/O
> > Architecture spec., and the beginning of IOMMU is based on DMAR tables...
> > If you have more info/guidance, I'd appreciate it.
> 
> Hm, I thought we'd already started doing some of that in order to
> sanity-check the DMAR tables. The VTBAR registers are in PCI config
> space. The quirk_ioat_snb_local_iommu() check is already looking at
> them...

I always had the impression that things like VTBAR registers are
entirely chipset specific (and may not be there for all chipsets).
Would be great if that's incorrect.  Any idea?

thanks,
-chris
