Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab1BUQHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:07:16 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:53035 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab1BUQHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:07:15 -0500
Date: Mon, 21 Feb 2011 17:06:59 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v6 2/3] memcg: move memcg reclaimable page into tail of
 inactive list
Message-ID: <20110221160659.GJ25382@cmpxchg.org>
References: <cover.1298212517.git.minchan.kim@gmail.com>
 <c76a1645aac12c3b8ffe2cc5738033f5a6da8d32.1298212517.git.minchan.kim@gmail.com>
 <20110221084014.GC25382@cmpxchg.org>
 <20110221155925.GA5641@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221155925.GA5641@barrios-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:59:25AM +0900, Minchan Kim wrote:
> Fixed version.
> 
> >From be7d31f6e539bbad1ebedf52c6a51a4a80f7976a Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan.kim@gmail.com>
> Date: Tue, 22 Feb 2011 00:53:05 +0900
> Subject: [PATCH v7 2/3] memcg: move memcg reclaimable page into tail of inactive list
> 
> The rotate_reclaimable_page function moves just written out
> pages, which the VM wanted to reclaim, to the end of the
> inactive list.  That way the VM will find those pages first
> next time it needs to free memory.
> This patch apply the rule in memcg.
> It can help to prevent unnecessary working page eviction of memcg.
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
