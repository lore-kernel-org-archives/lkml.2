Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2KPQJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:09:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab2KPQJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:09:17 -0500
Message-ID: <50A66513.3010900@redhat.com>
Date: Fri, 16 Nov 2012 11:08:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/43] mm: mempolicy: Use _PAGE_NUMA to migrate pages
References: <1353064973-26082-1-git-send-email-mgorman@suse.de> <1353064973-26082-15-git-send-email-mgorman@suse.de>
In-Reply-To: <1353064973-26082-15-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 06:22 AM, Mel Gorman wrote:
> Note: Based on "mm/mpol: Use special PROT_NONE to migrate pages" but
> 	sufficiently different that the signed-off-bys were dropped
>
> Combine our previous _PAGE_NUMA, mpol_misplaced and migrate_misplaced_page()
> pieces into an effective migrate on fault scheme.
>
> Note that (on x86) we rely on PROT_NONE pages being !present and avoid
> the TLB flush from try_to_unmap(TTU_MIGRATION). This greatly improves the
> page-migration performance.
>
> Based-on-work-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

(this is getting easier, I must have reviewed this code 4x now)

-- 
All rights reversed
