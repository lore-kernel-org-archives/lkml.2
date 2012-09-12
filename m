Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab2ILP2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:28:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab2ILP2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:28:03 -0400
Date: Wed, 12 Sep 2012 17:27:59 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 0/3] Minor changes to common hugetlb code for ARM
Message-ID: <20120912152759.GR21579@dhcp22.suse.cz>
References: <1347382036-18455-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347382036-18455-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-09-12 17:47:13, Will Deacon wrote:
> Hello,

Hi,

> A few changes are required to common hugetlb code before the ARM support
> can be merged. I posted the main one previously, which has been picked up
> by akpm:
> 
>   http://marc.info/?l=linux-mm&m=134573987631394&w=2
> 
> The remaining three patches (included here) are all fairly minor but do
> affect other architectures.

I am quite confused. Why THP changes are required for hugetlb code for
ARM?

Besides that I would suggest adding Andrea to the CC (added now the
whole series can be found here http://lkml.org/lkml/2012/9/11/322) list
for all THP changes.

> 
> All comments welcome,
> 
> Will
> 
> Catalin Marinas (2):
>   mm: thp: Fix the pmd_clear() arguments in pmdp_get_and_clear()
>   mm: thp: Fix the update_mmu_cache() last argument passing in
>     mm/huge_memory.c
> 
> Steve Capper (1):
>   mm: Introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE
> 
>  arch/x86/Kconfig              |    4 ++++
>  include/asm-generic/pgtable.h |    2 +-
>  mm/Kconfig                    |    2 +-
>  mm/huge_memory.c              |    6 +++---
>  4 files changed, 9 insertions(+), 5 deletions(-)
> 
> -- 
> 1.7.4.1
> 

-- 
Michal Hocko
SUSE Labs
