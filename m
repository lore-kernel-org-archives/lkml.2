Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab1AHW2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:28:47 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:52471 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1AHW2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:28:47 -0500
Date: Sat, 8 Jan 2011 23:28:39 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/7] swap: Change remove_from_page_cache
Message-ID: <20110108222838.GE23189@cmpxchg.org>
References: <cover.1293031046.git.minchan.kim@gmail.com>
 <4c25f88c476520c47e3b0217e09b6b2d58638685.1293031046.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c25f88c476520c47e3b0217e09b6b2d58638685.1293031046.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:32:46AM +0900, Minchan Kim wrote:
> This patch series changes remove_from_page_cache's page ref counting
> rule. Page cache ref count is decreased in delete_from_page_cache.
> So we don't need decreasing page reference by caller.
> 
> Cc:Hugh Dickins <hughd@google.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/shmem.c |    3 +--

Patch subject should probably say 'shmem' instead of 'swap'.

Otherwise,
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
