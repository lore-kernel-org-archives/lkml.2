Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2LQSRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:17:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab2LQSRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:17:37 -0500
Message-ID: <50CF618C.6020100@redhat.com>
Date: Mon, 17 Dec 2012 13:16:44 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] mm: vmscan: clarify how swappiness, highest priority,
 memcg interact
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org> <1355767957-4913-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1355767957-4913-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 01:12 PM, Johannes Weiner wrote:
> A swappiness of 0 has a slightly different meaning for global reclaim
> (may swap if file cache really low) and memory cgroup reclaim (never
> swap, ever).
>
> In addition, global reclaim at highest priority will scan all LRU
> lists equal to their size and ignore other balancing heuristics.
> UNLESS swappiness forbids swapping, then the lists are balanced based
> on recent reclaim effectiveness.  UNLESS file cache is running low,
> then anonymous pages are force-scanned.
>
> This (total mess of a) behaviour is implicit and not obvious from the
> way the code is organized.  At least make it apparent in the code flow
> and document the conditions.  It will be it easier to come up with
> sane semantics later.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
