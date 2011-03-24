Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab1CXIDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:03:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58396 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933179Ab1CXIDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:03:32 -0400
Date: Thu, 24 Mar 2011 09:03:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove dma32_reserve_bootmem
Message-ID: <20110324080326.GA30812@elte.hu>
References: <4D8AD6E0.10307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8AD6E0.10307@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> That is workaround for holding dma32 buf when early bootmem could use up
> those range on system that have lots of RAM.
> 
> Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.
> 
> So We could remove those not needed code now.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/pci.h |    2 -
>  arch/x86/kernel/pci-dma.c  |   64 ---------------------------------------------
>  arch/x86/kernel/setup.c    |    1
>  3 files changed, 67 deletions(-)

Cc:-ing Jesse - i suspect this should be handled by the PCI tree.

Thanks,

	Ingo
