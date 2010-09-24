Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab0IXJVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:21:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41647 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0IXJVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:21:46 -0400
Date: Fri, 24 Sep 2010 11:21:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] AMD IOMMU fixes for 2.6.36
Message-ID: <20100924092135.GA23971@elte.hu>
References: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 49553c2ef88749dd502687f4eb9c258bb10a4f44:
>   Linus Torvalds (1):
>         Linux 2.6.36-rc4
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.36
> 
> Joerg Roedel (3):
>       x86/amd-iommu: Set iommu configuration flags in enable-loop
>       x86/amd-iommu: Work around S3 BIOS bug
>       x86/amd-iommu: Fix rounding-bug in __unmap_single
> 
>  arch/x86/include/asm/amd_iommu_proto.h |    6 +++
>  arch/x86/include/asm/amd_iommu_types.h |   12 ++++++
>  arch/x86/kernel/amd_iommu.c            |    4 +-
>  arch/x86/kernel/amd_iommu_init.c       |   67 +++++++++++++++++++++----------
>  include/linux/pci_ids.h                |    3 +
>  5 files changed, 69 insertions(+), 23 deletions(-)
>
> The first two patches make resume from memory working with the AMD 
> IOMMU driver (one fixes a problem in the driver and the other works 
> around a BIOS bug). The third patch fixes a long standing rounding bug 
> in the driver which may lead to stale io/tlb entries. Please pull.

Pulled, thanks Joerg!

	Ingo
