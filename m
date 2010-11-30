Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab0K3TZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:25:37 -0500
Received: from canuck.infradead.org ([134.117.69.58]:41761 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab0K3TZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:25:36 -0500
Subject: Re: [PATCH 09/21] powerpc: Preemptible mmu_gather
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <1291088148.32570.342.camel@pasglop>
References: <20101126143843.801484792@chello.nl>
	 <20101126145410.771278578@chello.nl>  <1291086726.32570.341.camel@pasglop>
	 <1291088148.32570.342.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Nov 2010 20:25:13 +0100
Message-ID: <1291145113.32004.1152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 14:35 +1100, Benjamin Herrenschmidt wrote:
> > This breaks embedded 64-bit build. Replace CONFIG_PPC64 with
> > CONFIG_PPC_BOOK3S_64 to only hit server when you access the
> > ppc64_tlb_batch in process.c since it doesn't exist for BOOK3E.
> > 
> > This patch to fold into yours fixes it for me:
> 
> With this fix and the other Kconfig fix, it seems to boot fine and no
> obvious breakage doing simple things on G5 and a power6 machine.

Awesome, thanks for your fixes, I've folded them in the respective
patches.


