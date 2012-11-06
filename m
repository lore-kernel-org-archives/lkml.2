Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2KFRdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 12:33:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab2KFRc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 12:32:59 -0500
Message-ID: <50994A58.9000309@redhat.com>
Date: Tue, 06 Nov 2012 12:35:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/19] mm: compaction: Add scanned and isolated counters
 for compaction
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1352193295-26815-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 04:14 AM, Mel Gorman wrote:
> Compaction already has tracepoints to count scanned and isolated pages
> but it requires that ftrace be enabled and if that information has to be
> written to disk then it can be disruptive. This patch adds vmstat counters
> for compaction called compact_migrate_scanned, compact_free_scanned and
> compact_isolated.
>
> With these counters, it is possible to define a basic cost model for
> compaction. This approximates of how much work compaction is doing and can
> be compared that with an oprofile showing TLB misses and see if the cost of
> compaction is being offset by THP for example. Minimally a compaction patch
> can be evaluated in terms of whether it increases or decreases cost. The
> basic cost model looks like this


> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


