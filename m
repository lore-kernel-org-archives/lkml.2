Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0JURDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:03:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36513 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0JURDA (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 21 Oct 2010 13:03:00 -0400
Date: Thu, 21 Oct 2010 13:02:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/iommu for v2.6.37
Message-ID: <20101021170216.GA2640@dumpdata.com>
References: <20101021135043.GA6670@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021135043.GA6670@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 03:50:43PM +0200, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest x86-iommu-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-iommu-for-linus
> 
> 
> out-of-topic modifications in x86-iommu-for-linus:
> --------------------------------------------------
> arch/ia64/include/asm/iommu_table.h# fc6a2f3: ia64, iommu: Add a dummy iommu_ta
> drivers/pci/dmar.c                 # 4db77ff: x86, VT-d: Make Intel VT-d IOMMU 
>                                    # 480125b: x86, iommu: Make all IOMMU's dete
> include/linux/dmar.h               # 480125b: x86, iommu: Make all IOMMU's dete
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Konrad Rzeszutek Wilk (14):
>       x86, iommu: Add IOMMU_INIT macros, .iommu_table section, and iommu_table_entry structure
>       x86, iommu: Make all IOMMU's detection routines return a value.
>       x86, iommu: Add proper dependency sort routine (and sanity check).
>       x86, swiotlb: Simplify SWIOTLB pci_swiotlb_detect routine.
>       x86, swiotlb: Make SWIOTLB use IOMMU_INIT_* macros.
>       x86, xen-swiotlb: Make Xen-SWIOTLB use IOMMU_INIT_* macros.
>       x86, calgary: Make Calgary IOMMU use IOMMU_INIT_* macros.

I initially did not have a IBM box with a Calgary chipset, but about a week
ago got one cheap on eBay so was able to test this. 

>       x86, GART/AMD-VI: Make AMD GART and IOMMU use IOMMU_INIT_* macros.
>       x86, VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_* macros.
And also this one.
>       x86, iommu: Utilize the IOMMU_INIT macros functionality.
>       x86, doc: Adding comments about .iommu_table and its neighbors.
>       x86, iommu: Fix IOMMU_INIT alignment rules
>       ia64, iommu: Add a dummy iommu_table.h file in IA64.
>       x86, iommu: Update header comments with appropriate naming
