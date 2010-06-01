Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0FAJqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:46:14 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:53089 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab0FAJqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:46:12 -0400
Date: Tue, 1 Jun 2010 11:45:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] amd iommu fixes for 2.6.35-rc1
Message-ID: <20100601094558.GA22265@elte.hu>
References: <1275383021-20172-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275383021-20172-1-git-send-email-joerg.roedel@amd.com>
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
> The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:
> 
>   Linux 2.6.35-rc1 (2010-05-30 13:21:02 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.35
> 
> Joerg Roedel (3):
>       Merge commit 'v2.6.35-rc1' into amd-iommu/2.6.35
>       x86/amd-iommu: Fix crash when request_mem_region fails
>       x86/amd-iommu: Fall back to GART if initialization fails
> 
> Julia Lawall (1):
>       arch/x86/kernel: Add missing spin_unlock
> 
>  arch/x86/kernel/amd_iommu.c      |   16 +++++++++-------
>  arch/x86/kernel/amd_iommu_init.c |   20 +++++++++++++++++---
>  2 files changed, 26 insertions(+), 10 deletions(-)
> 
> These patches fix two bugs in the error-paths of the amd iommu driver. One 
> fix adds missing spin_unlocks and the other two patches fix a problem with 
> broken BIOSes where the driver can't allocate the mmio region for the iommu 
> hardware. Please pull.

Pulled, thanks Joerg!

	Ingo
