Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2LRKEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:04:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094Ab2LRKEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:04:53 -0500
Date: Tue, 18 Dec 2012 10:04:50 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] mm: vmscan: clarify how swappiness, highest
 priority, memcg interact
Message-ID: <20121218100449.GK9887@suse.de>
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
 <1355767957-4913-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1355767957-4913-4-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 01:12:33PM -0500, Johannes Weiner wrote:
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

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
