Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1AHWdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:33:10 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:55187 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab1AHWdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:33:09 -0500
Date: Sat, 8 Jan 2011 23:33:01 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5/7] truncate: Change remove_from_page_cache
Message-ID: <20110108223300.GF23189@cmpxchg.org>
References: <cover.1293031046.git.minchan.kim@gmail.com>
 <fdafb3fb6ed32ec96f945fdbdd42bd6492d00cd7.1293031047.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdafb3fb6ed32ec96f945fdbdd42bd6492d00cd7.1293031047.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:32:47AM +0900, Minchan Kim wrote:
> This patch series changes remove_from_page_cache's page ref counting
> rule. Page cache ref count is decreased in delete_from_page_cache.
> So we don't need decreasing page reference by caller.
> 
> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: linux-mm@kvack.org
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
