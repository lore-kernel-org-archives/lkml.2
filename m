Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab2KFRaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 12:30:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab2KFRaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 12:30:00 -0500
Message-ID: <5099499D.4050304@redhat.com>
Date: Tue, 06 Nov 2012 12:32:13 -0500
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
Subject: Re: [PATCH 01/19] mm: compaction: Move migration fail/success stats
 to migrate.c
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1352193295-26815-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 04:14 AM, Mel Gorman wrote:
> The compact_pages_moved and compact_pagemigrate_failed events are
> convenient for determining if compaction is active and to what
> degree migration is succeeding but it's at the wrong level. Other
> users of migration may also want to know if migration is working
> properly and this will be particularly true for any automated
> NUMA migration. This patch moves the counters down to migration
> with the new events called pgmigrate_success and pgmigrate_fail.
> The compact_blocks_moved counter is removed because while it was
> useful for debugging initially, it's worthless now as no meaningful
> conclusions can be drawn from its value.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

