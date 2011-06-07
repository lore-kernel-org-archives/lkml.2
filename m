Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1FGKnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:43:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35744 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1FGKnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:43:42 -0400
Date: Tue, 7 Jun 2011 12:43:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] AMD IOMMU fixes for 3.0-rc2
Message-ID: <20110607104331.GC21356@elte.hu>
References: <1307441219-18202-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307441219-18202-1-git-send-email-joerg.roedel@amd.com>
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
> The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:
> 
>   Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/fixes
> 
> Joerg Roedel (3):
>       x86/amd-iommu: Fix 3 possible endless loops
>       x86/amd-iommu: Use only per-device dma_ops
>       x86/amd-iommu: Fix boot crash with hidden PCI devices
> 
>  arch/x86/kernel/amd_iommu.c      |   48 +++++++++++++++++++++++++++++++++++--
>  arch/x86/kernel/amd_iommu_init.c |    8 +++---
>  2 files changed, 49 insertions(+), 7 deletions(-)
> 
> These patches fix serious issues which were discovered recently like a
> boot-stall and a boot crash when a device has an alias which does not exist a
> pci_dev. Please pull.

Pulled, thanks a lot Joerg!

	Ingo
