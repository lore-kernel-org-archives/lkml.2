Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0HAGsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:48:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49909 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab0HAGsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:48:37 -0400
Date: Sun, 1 Aug 2010 08:48:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] IOMMU updates for 2.6.36
Message-ID: <20100801064827.GA19913@elte.hu>
References: <1280249030-21332-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280249030-21332-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit b37fa16e78d6f9790462b3181602a26b5af36260:
>   Linus Torvalds (1):
>         Linux 2.6.35-rc6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/2.6.36
> 
> Joerg Roedel (2):
>       x86/amd-iommu: Export cache-coherency capability
>       Merge branches 'iommu-api/2.6.36' and 'amd-iommu/2.6.36' into iommu/2.6.36
> 
> Kulikov Vasiliy (1):
>       x86/amd-iommu: Use for_each_pci_dev()
> 
> Tom Lyon (1):
>       iommu-api: Extension to check for interrupt remapping
> 
>  arch/x86/kernel/amd_iommu.c |    8 ++++++--
>  drivers/pci/intel-iommu.c   |    2 ++
>  include/linux/iommu.h       |    1 +
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> The changes are all minor. There is one cleanup patch, and two patches that
> extend the capabilities exported by the IOMMU-API. Please pull.

Pulled, thanks Joerg!

	Ingo
