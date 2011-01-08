Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1AHWfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:35:50 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35607 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1AHWft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:35:49 -0500
Date: Sat, 8 Jan 2011 23:35:43 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 6/7] Good bye remove_from_page_cache
Message-ID: <20110108223543.GG23189@cmpxchg.org>
References: <cover.1293031046.git.minchan.kim@gmail.com>
 <958620cb6a73a5633619d7d4a9793bc284260684.1293031047.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <958620cb6a73a5633619d7d4a9793bc284260684.1293031047.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:32:48AM +0900, Minchan Kim wrote:
> Now delete_from_page_cache replaces remove_from_page_cache.
> So we remove remove_from_page_cache so fs or something out of
> mainline will notice it when compile time and can fix it.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
