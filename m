Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab2KNR7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:59:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab2KNR7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:59:05 -0500
Message-ID: <50A3DBCD.8010503@redhat.com>
Date: Wed, 14 Nov 2012 12:58:37 -0500
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
Subject: Re: [PATCH 16/31] mm: numa: Only call task_numa_placement for misplaced
 pages
References: <1352805180-1607-1-git-send-email-mgorman@suse.de> <1352805180-1607-17-git-send-email-mgorman@suse.de>
In-Reply-To: <1352805180-1607-17-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 06:12 AM, Mel Gorman wrote:
> task_numa_placement is potentially very expensive so limit it to being
> called when a page is misplaced. How necessary this is depends on
> the placement policy.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

That reads like a premature optimization :)

-- 
All rights reversed
