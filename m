Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab2AFXzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:55:05 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41995 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247Ab2AFXy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:54:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120105151535.GA10472@elte.hu>
References: <20120105151535.GA10472@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2012 15:54:34 -0800
X-Google-Sender-Auth: Y2qlODwpaZLV1M2nrzBNLO5IwCQ
Message-ID: <CA+55aFy==CaiVRR+6f6c68Q69sXJFRQ86mw5rmjiYD0zXM+y8A@mail.gmail.com>
Subject: Re: [GIT PULL] x86/mm changes for v3.3
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 7:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest x86-mm-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

What I get from there does not match what you describe AT ALL:

> H Hartley Sweeten (1):
>      arch/x86/kernel/e820.c: quiet sparse noise about plain integer as NULL pointer
>
> Ludwig Nussel (1):
>      x86: Fix mmap random address range
>
> Mike Ditto (1):
>      arch/x86/kernel/e820.c: Eliminate bubble sort from sanitize_e820_map()
>
> Pekka Enberg (7):
>      x86, mm: Use MAX_DMA_PFN for ZONE_DMA on 32-bit
>      x86, mm: Move zone init from paging_init() on 64-bit
>      x86, mm: Use max_pfn instead of highend_pfn
>      x86, mm: Wrap ZONE_DMA32 with CONFIG_ZONE_DMA32
>      x86, mm: Use max_low_pfn for ZONE_NORMAL on 64-bit
>      x86, mm: Prepare zone_sizes_init() for unification
>      x86, mm: Unify zone_sizes_init()
>
> Petr Holasek (1):
>      x86/numa: Add constraints check for nid parameters
>
> Stanislaw Gruszka (2):
>      x86/mm: Initialize high mem before free_all_bootmem()
>      mm, x86: Remove debug_pagealloc_enabled

Instead of the above, I see

  Stefano Stabellini (5):
      x86, mm: Calculate precisely the memory needed by init_memory_mapping
      Revert "x86,xen: introduce x86_init.mapping.pagetable_reserve"
      x86, init : Move memblock_x86_reserve_range PGTABLE to
find_early_table_space
      x86-64, mm: Do not assume head_64.S used 4KB pages when !use_pse
      x86_32: Calculate additional memory needed by the fixmap

which is old and crappy.

What the heck is going on, Ingo?

                      Linus
