Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0JMNpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:45:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55857 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab0JMNpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:45:11 -0400
Date: Wed, 13 Oct 2010 15:45:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.37
Message-ID: <20101013134501.GA2258@elte.hu>
References: <1286973364-17077-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286973364-17077-1-git-send-email-joerg.roedel@amd.com>
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
> The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:
>   Linus Torvalds (1):
>         Linux 2.6.36-rc6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.37
> 
> Joerg Roedel (1):
>       x86/amd-iommu: Update copyright headers
> 
> Matthew Garrett (1):
>       x86/amd-iommu: Reenable AMD IOMMU if it's mysteriously vanished over suspend
> 
>  arch/x86/include/asm/amd_iommu.h       |    2 +-
>  arch/x86/include/asm/amd_iommu_proto.h |    2 +-
>  arch/x86/include/asm/amd_iommu_types.h |   23 ++++--
>  arch/x86/kernel/amd_iommu.c            |    2 +-
>  arch/x86/kernel/amd_iommu_init.c       |  124 ++++++++++++++++++++++++++++----
>  5 files changed, 128 insertions(+), 25 deletions(-)
> 
> This update is mostly about a workaround for BIOS problems with AMD 
> IOMMU when resuming from S3. The BIOS on an AMD IOMMU capable machine 
> might be buggy so that the IOMMU device is not re-enabled on resume. 
> The patch from Matthew implement a workaround for this problem by 
> manually re-enabling an re-programming the IOMMU device on resume. 
> Please pull.

Pulled, thanks a lot Joerg!

	Ingo
