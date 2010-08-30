Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0H3Odd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:33:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22554 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab0H3Odb (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 30 Aug 2010 10:33:31 -0400
Date: Mon, 30 Aug 2010 10:32:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: pci_iommu_init() crash
Message-ID: <20100830143206.GB5652@phenom.dumpdata.com>
References: <20100829173216.GA19896@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100829173216.GA19896@elte.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 07:32:16PM +0200, Ingo Molnar wrote:
> 
> FYI, -tip testing found a new boot crash, caused by the new x86/iommu 
> commits:
> 
> 6f44d03: x86, doc: Adding comments about .iommu_table and its neighbors.
> ee1f284: x86, iommu: Utilize the IOMMU_INIT macros functionality.
> 4db77ff: x86, VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_* macros.
> 22e6daf: x86, GART/AMD-VI: Make AMD GART and IOMMU use IOMMU_INIT_* macros.
> d2aa232: x86, calgary: Make Calgary IOMMU use IOMMU_INIT_* macros.
> 5cb3a26: x86, xen-swiotlb: Make Xen-SWIOTLB use IOMMU_INIT_* macros.
> c116c54: x86, swiotlb: Make SWIOTLB use IOMMU_INIT_* macros.
> efa631c: x86, swiotlb: Simplify SWIOTLB pci_swiotlb_detect routine.
> 5bef80a: x86, iommu: Add proper dependency sort routine (and sanity check).
> 480125b: x86, iommu: Make all IOMMU's detection routines return a value.
> 0444ad9: x86, iommu: Add IOMMU_INIT macros, .iommu_table section, and iommu_table_entry structure
> 
> Crashlog is below, config attached. I've excluded x86/iommu from 
> tip:master for now.

Fixing it right now. Thanks for the e-mail.

