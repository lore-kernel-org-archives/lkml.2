Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0DMLZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 07:25:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab0DMLZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:25:37 -0400
Date: Tue, 13 Apr 2010 13:25:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL][PATCH 0/12] IOMMU fixes for 2.6.34-rc3
Message-ID: <20100413112510.GB19757@elte.hu>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
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
> The following changes since commit 2eaa9cfdf33b8d7fb7aff27792192e0019ae8fc6:
>   Linus Torvalds (1):
>         Linux 2.6.34-rc3
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes
> 
> Chris Wright (5):
>       x86/amd-iommu: Pt mode fix for domain_destroy
>       x86/amd-iommu: enable iommu before attaching devices
>       x86/amd-iommu: warn when issuing command to uninitialized cmd buffer
>       Revert "x86: disable IOMMUs on kernel crash"
>       x86/amd-iommu: use for_each_pci_dev
> 
> Dan Carpenter (1):
>       dma-debug: Cleanup for copy-loop in filter_write()
> 
> Joerg Roedel (6):
>       x86/amd-iommu: Protect IOMMU-API map/unmap path
>       x86/amd-iommu: Report errors in acpi parsing functions upstream
>       x86/amd-iommu: Use helper function to destroy domain
>       x86/amd-iommu: Remove obsolete parameter documentation
>       Merge branch 'amd-iommu/fixes' into iommu/fixes
>       x86/gart: Disable GART explicitly before initialization
> 
> Julia Lawall (1):
>       x86/amd-iommu: Remove double NULL check in check_device
> 
>  Documentation/kernel-parameters.txt    |    5 ---
>  arch/x86/include/asm/amd_iommu_types.h |    3 ++
>  arch/x86/kernel/amd_iommu.c            |   20 +++++++++----
>  arch/x86/kernel/amd_iommu_init.c       |   48 ++++++++++++++++++++++----------
>  arch/x86/kernel/aperture_64.c          |   15 +++++++++-
>  arch/x86/kernel/crash.c                |    6 ----
>  arch/x86/kernel/pci-gart_64.c          |    3 ++
>  lib/dma-debug.c                        |    2 +-
>  8 files changed, 68 insertions(+), 34 deletions(-)
> 
> This pull request includes fixes that did not made it upstream during the merge
> window, fixes for recently discovered problems with kdump and amd-iommu
> enabled and a small documentation update. Please pull.

Pulled, thanks a lot Joerg!

	Ingo
