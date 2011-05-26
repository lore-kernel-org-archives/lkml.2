Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab1EZOD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:03:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:51058 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616Ab1EZOD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:03:26 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1306387374.7481.451.camel@pasglop>
Date: Thu, 26 May 2011 09:02:45 -0500
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C1E4ECF7-17CD-4A32-941D-FE53137F94EC@kernel.crashing.org>
References: <1306387374.7481.451.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 26, 2011, at 12:22 AM, Benjamin Herrenschmidt wrote:

> Hi Linus !
> 
> This is a bit more than I expected to send you that late in the merge
> window, but hopefully none of it should be problematic. A couple of
> patches were simply delayed due to misunderstandings as to which tree
> they should go through (4xx MSI and ftrace).
> 
> There's a generic patch to linux/smp.h which removes some definitions
> that as far as we can tell aren't used anywhere anymore (we just removed
> the last use in powerpc in my previous pull request).
> 
> The rest is either good enough bug fixes (in large part regressions),
> with a couple more cleanups from Milton on top of his big series that
> I merged earlier.
> 
> Cheers,
> Ben.
> 
> The following changes since commit 3f5785ec31adcb7cafa9135087297a38d9698cf8:
> 
>  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-05-25 17:00:17 -0700)
> 
> are available in the git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git ..BRANCH.NOT.VERIFIED..
> 
> Brian King (1):
>      powerpc/pseries: Update MAX_HCALL_OPCODE to reflect page coalescing
> 
> Eric B Munson (1):
>      powerpc/oprofile: Handle events that raise an exception without overflowing
> 
> Ian Munsie (1):
>      powerpc/ftrace: Implement raw syscall tracepoints on PowerPC
> 
> Milton Miller (8):
>      Remove unused MSG_ flags in linux/smp.h
>      powerpc/cell: Use common smp ipi actions
>      powerpc/cell: Rename ipi functions to match current abstractions
>      powerpc/irq: Remove stale and misleading comment
>      powerpc/irq: Always free duplicate IRQ_LEGACY hosts
>      powerpc/irq: Check desc in handle_one_irq and expand generic_handle_irq
>      powerpc/irq: Protect irq_radix_revmap_lookup against irq_free_virt
>      powerpc: Fix irq_free_virt by adjusting bounds before loop
> 
> Rupjyoti Sarmah (1):
>      powerpc/4xx: Adding PCIe MSI support

Ben,

Did you ignore my pull request with a bug fix and two long standing RIO patches?

- k