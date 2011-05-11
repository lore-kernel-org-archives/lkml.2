Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab1EKREf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:04:35 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:34997 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1EKREd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:04:33 -0400
Date: Wed, 11 May 2011 08:21:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] (AMD mostly) IOMMU updates for 2.6.40
Message-ID: <20110511062124.GA22551@elte.hu>
References: <20110510163623.GI30996@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510163623.GI30996@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 693d92a1bbc9e42681c42ed190bd42b636ca876f:
> 
>   Linux 2.6.39-rc7 (2011-05-09 19:33:54 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/2.6.40
> 
> Joe Perches (1):
>       arch/x86/kernel/pci-iommu_table.c: Convert sprintf_symbol to %pS
> 
> Joerg Roedel (18):
>       x86/amd-iommu: Move compl-wait command building to own function
>       x86/amd-iommu: Move inv-dte command building to own function
>       x86/amd-iommu: Cleanup inv_pages command handling
>       x86/amd-iommu: Cleanup completion-wait handling
>       x86/amd-iommu: Remove command buffer resetting logic
>       x86/amd-iommu: Rename iommu_flush* to domain_flush*
>       x86/amd-iommu: Improve handling of full command buffer
>       x86/amd-iommu: Rename iommu_flush_device
>       x86/amd-iommu: Flush all internal TLBs when IOMMUs are enabled
>       PCI: Move ATS declarations in seperate header file
>       x86/amd-iommu: Select PCI_IOV with AMD IOMMU driver
>       x86/amd-iommu: Flush device IOTLB if ATS is enabled
>       x86/amd-iommu: Add flag to indicate IOTLB support
>       x86/amd-iommu: Add ATS enable/disable code
>       x86/amd-iommu: Add extended feature detection
>       x86/amd-iommu: Add support for invalidate_all command
>       Merge branches 'dma-debug/next', 'amd-iommu/command-cleanups', 'amd-iommu/ats' and 'amd-iommu/extended-features' into iommu/2.6.40
>       x86/amd-iommu: Use threaded interupt handler
> 
> Stanislaw Gruszka (1):
>       dma-debug: print information about leaked entry
> 
>  arch/x86/Kconfig                       |    1 +
>  arch/x86/include/asm/amd_iommu_proto.h |   13 +-
>  arch/x86/include/asm/amd_iommu_types.h |   28 ++-
>  arch/x86/kernel/amd_iommu.c            |  526 +++++++++++++++++++-------------
>  arch/x86/kernel/amd_iommu_init.c       |   48 +++-
>  arch/x86/kernel/pci-iommu_table.c      |   18 +-
>  drivers/pci/intel-iommu.c              |    1 +
>  drivers/pci/iov.c                      |    1 +
>  drivers/pci/pci.h                      |   37 ---
>  include/linux/pci-ats.h                |   52 ++++
>  lib/dma-debug.c                        |   18 +-
>  11 files changed, 454 insertions(+), 289 deletions(-)
>  create mode 100644 include/linux/pci-ats.h

Pulled, thanks a lot Joerg!

Thanks,

	Ingo
