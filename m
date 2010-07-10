Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0GJPLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 11:11:15 -0400
Received: from 8bytes.org ([88.198.83.132]:50990 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0GJPLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 11:11:13 -0400
Date: Sat, 10 Jul 2010 17:11:11 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: Andi Kleen <andi@firstfloor.org>, Daniel Walker <dwalker@codeaurora.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, mel@csn.ul.ie,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
Message-ID: <20100710151111.GD10080@8bytes.org>
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com> <20100701180241.GA3594@basil.fritz.box> <1278012503.7738.17.camel@c-dwalke-linux.qualcomm.com> <20100701193850.GB3594@basil.fritz.box> <4C2D0FF1.6010206@codeaurora.org> <20100701230056.GD3594@basil.fritz.box> <4C2D847E.5080602@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2D847E.5080602@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 11:17:34PM -0700, Zach Pfeffer wrote:
> Andi Kleen wrote:

> > Hmm? dma_map_* does not change any CPU mappings. It only sets up
> > DMA mapping(s).
> 
> Sure, but I was saying that iommu_map() doesn't just set up the IOMMU
> mappings, its sets up both the iommu and kernel buffer mappings.

What do you mean by kernel buffer mappings?


> > That assumes that all the IOMMUs on the system support the same page table
> > format, right?
> 
> Actually no. Since the VCMM abstracts a page-table as a Virtual
> Contiguous Region (VCM) a VCM can be associated with any device,
> regardless of their individual page table format.

The IOMMU-API abstracts a page-table as a domain which can also be
associated with any device (behind an iommu).

	Joerg

