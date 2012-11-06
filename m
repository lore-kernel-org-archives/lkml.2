Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2KFTIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:08:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2KFTIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:08:09 -0500
Message-ID: <509960A4.30407@redhat.com>
Date: Tue, 06 Nov 2012 14:10:28 -0500
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
Subject: Re: [PATCH 12/19] mm: migrate: Introduce migrate_misplaced_page()
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-13-git-send-email-mgorman@suse.de>
In-Reply-To: <1352193295-26815-13-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 04:14 AM, Mel Gorman wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Note: This was originally based on Peter's patch "mm/migrate: Introduce
> 	migrate_misplaced_page()" but borrows extremely heavily from Andrea's
> 	"autonuma: memory follows CPU algorithm and task/mm_autonuma stats
> 	collection". The end result is barely recognisable so signed-offs
> 	had to be dropped. If original authors are ok with it, I'll
> 	re-add the signed-off-bys.
>
> Add migrate_misplaced_page() which deals with migrating pages from
> faults.
>
> Based-on-work-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Based-on-work-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Based-on-work-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Excellent, this avoids the ugliness in Peter's
approach, and the hard to read maze of functions
from Andrea's tree.

Reviewed-by: Rik van Riel <riel@redhat.com>


