Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1BROsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:48:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab1BROsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:48:43 -0500
Message-ID: <4D5E86DF.8070805@redhat.com>
Date: Fri, 18 Feb 2011 09:49:03 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 3/3] mm: Simplify anon_vma refcounts
References: <20110217161948.045410404@chello.nl>	 <20110217162124.457572646@chello.nl>	 <AANLkTimj1d6QpzuNZ6NJvLDVvvC++mPodggFaBziU8Bj@mail.gmail.com> <1298036683.5226.765.camel@laptop>
In-Reply-To: <1298036683.5226.765.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2011 08:44 AM, Peter Zijlstra wrote:
> Subject: mm: Simplify anon_vma refcounts
> From: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Date: Fri, 26 Nov 2010 15:38:49 +0100
>
> This patch changes the anon_vma refcount to be 0 when the object is
> free. It does this by adding 1 ref to being in use in the anon_vma
> structure (iow. the anon_vma->head list is not empty).
>
> This allows a simpler release scheme without having to check both the
> refcount and the list as well as avoids taking a ref for each entry
> on the list.
>
> Reviewed-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Hugh Dickins<hughd@google.com>
> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>

Acked-by: Rik van Riel <riel@redhat.com>
