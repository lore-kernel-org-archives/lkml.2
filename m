Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1CGRyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:54:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1CGRys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:54:48 -0500
Subject: Re: [RFC][PATCH 14/15] mm, sparc32: Convert sparc32 to generic tlb
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>, Russell King <rmk@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20110307172207.445811237@chello.nl>
References: <20110307171350.989666626@chello.nl>
	 <20110307172207.445811237@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 07 Mar 2011 18:54:12 +0100
Message-ID: <1299520452.2308.240.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 18:14 +0100, Peter Zijlstra wrote:
> plain text document attachment (sparc32-mmu_range.patch)
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/sparc/Kconfig              |    1 +
>  arch/sparc/include/asm/tlb_32.h |   10 ----------
>  2 files changed, 1 insertion(+), 10 deletions(-)
> 
> Index: linux-2.6/arch/sparc/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/sparc/Kconfig
> +++ linux-2.6/arch/sparc/Kconfig
> @@ -25,6 +25,7 @@ config SPARC
>  	select HAVE_DMA_ATTRS
>  	select HAVE_DMA_API_DEBUG
>  	select HAVE_ARCH_JUMP_LABEL
> +	select HAVE_MMU_GATHER_RANGE
>  
>  config SPARC32
>  	def_bool !64BIT

Ah, I probably should put that in the SPARC32 bit.. ;-)
