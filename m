Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1AHWgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:36:22 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35614 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab1AHWgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:36:21 -0500
Date: Sat, 8 Jan 2011 23:36:17 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 7/7] Change __remove_from_page_cache
Message-ID: <20110108223616.GH23189@cmpxchg.org>
References: <cover.1293031046.git.minchan.kim@gmail.com>
 <6661e5a219276b590365774d90ec8e300956a3ad.1293031047.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6661e5a219276b590365774d90ec8e300956a3ad.1293031047.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:32:49AM +0900, Minchan Kim wrote:
> Now we renamed remove_from_page_cache with delete_from_page_cache.
> As consistency of __remove_from_swap_cache and remove_from_swap_cache,
> We change internal page cache handling function name, too.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
