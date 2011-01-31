Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1AaKCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:02:42 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:37240 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1AaKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:02:40 -0500
Date: Mon, 31 Jan 2011 11:02:37 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 00/21] mm: Preemptibility -v6
Message-ID: <20110131110237.41d48000@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1295457039.28776.137.camel@laptop>
References: <20101126143843.801484792@chello.nl>
	<alpine.LSU.2.00.1101172301340.2899@sister.anvils>
	<1295457039.28776.137.camel@laptop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011 18:10:39 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2011-01-17 at 23:12 -0800, Hugh Dickins wrote:
> 
> > 11/21 s390-preemptible_mmu_gather.patch
> >       I'd prefer __tlb_alloc_page(), with __GFP_NOWARN as suggested above.
> >       mm/pgtable.c still has DEFINE_PER_CPU(struct mmu_gather, mmu_gathers).
> 
> Martin, while doing the below DEFINE_PER_CPU removal I saw you had a
> bunch of RCU table removal thingies in arch/s390/mm/pgtable.c, could
> s390 use the generic bits like sparc and powerpc (see patch 16)?

Maybe, I will have a look at it.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

