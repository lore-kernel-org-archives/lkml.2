Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1AHWWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:22:22 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44249 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab1AHWWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:22:21 -0500
Date: Sat, 8 Jan 2011 23:22:11 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/7] fuse: Change remove_from_page_cache
Message-ID: <20110108222211.GC23189@cmpxchg.org>
References: <cover.1293031046.git.minchan.kim@gmail.com>
 <83e28e12e0c671777213e4a0d4fcc3b53c93ea1e.1293031046.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83e28e12e0c671777213e4a0d4fcc3b53c93ea1e.1293031046.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:32:44AM +0900, Minchan Kim wrote:
> This patch series changes remove_from_page_cache's page ref counting
> rule. Page cache ref count is decreased in delete_from_page_cache.
> So we don't need decreasing page reference by caller.
> 
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: fuse-devel@lists.sourceforge.net
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
