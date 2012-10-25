Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294Ab2JYU6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:58:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:43823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab2JYU6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,650,1344236400"; 
   d="scan'208";a="210899331"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 10/31] mm/mpol: Remove NUMA_INTERLEAVE_HIT
References: <20121025121617.617683848@chello.nl>
	<20121025124833.247790041@chello.nl>
Date: Thu, 25 Oct 2012 13:58:48 -0700
In-Reply-To: <20121025124833.247790041@chello.nl> (Peter Zijlstra's message of
	"Thu, 25 Oct 2012 14:16:27 +0200")
Message-ID: <m2txtiqnef.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> Since the NUMA_INTERLEAVE_HIT statistic is useless on its own; it wants
> to be compared to either a total of interleave allocations or to a miss
> count, remove it.

NACK, as already posted several times.

This breaks the numactl test suite, which is the only way currently to
test interleaving.

Please don't ignore review feedback.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
