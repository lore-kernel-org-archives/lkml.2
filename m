Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab0ELGS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:18:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52708 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab0ELGS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:18:56 -0400
Date: Wed, 12 May 2010 08:18:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [git pull] AMD IOMMU updates for 2.6.35
Message-ID: <20100512061826.GD537@elte.hu>
References: <20100511155319.GH22296@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511155319.GH22296@amd.com>
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
> The following changes since commit b57f95a38233a2e73b679bea4a5453a1cc2a1cc9:
> 
>   Linux 2.6.34-rc7 (2010-05-09 18:36:28 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.35
> 
> Joerg Roedel (12):
>       iommu-api: Rename ->{un}map function pointers to ->{un}map_range
>       iommu-api: Add iommu_map and iommu_unmap functions
>       iommu-api: Add ->{un}map callbacks to iommu_ops
>       VT-d: Change {un}map_range functions to implement {un}map interface
>       kvm: Change kvm_iommu_map_pages to map large pages
>       x86/amd-iommu: Make iommu_map_page and alloc_pte aware of page sizes
>       x86/amd-iommu: Make iommu_unmap_page and fetch_pte aware of page sizes
>       x86/amd-iommu: Make amd_iommu_iova_to_phys aware of multiple page sizes
>       x86/amd-iommu: Implement ->{un}map callbacks for iommu-api
>       iommu-api: Remove iommu_{un}map_range functions
>       x86/amd-iommu: Add amd_iommu=off command line option
>       Merge branch 'iommu/largepages' into amd-iommu/2.6.35
> 
>  Documentation/kernel-parameters.txt    |    2 +
>  arch/x86/include/asm/amd_iommu_types.h |   34 ++++++
>  arch/x86/kernel/amd_iommu.c            |  197 ++++++++++++++++++++------------
>  arch/x86/kernel/amd_iommu_init.c       |    6 +
>  drivers/base/iommu.c                   |   43 +++++---
>  drivers/pci/intel-iommu.c              |   22 ++--
>  include/linux/iommu.h                  |   24 ++--
>  virt/kvm/iommu.c                       |  113 +++++++++++++++----
>  8 files changed, 312 insertions(+), 129 deletions(-)
> 
> This pull request consists mostly of the patches for the IOMMU large
> page support and the associated AMD IOMMU driver changes. The code also
> touches KVM files. I asked Avi if it is ok if these changes go through
> -tip and he is fine with that. Beside the largepage code it includes one
> more patch which adds an amd_iommu=off command line parameter. Please
> pull.

Pulled, thanks Joerg!

	Ingo
