Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2CWBsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 21:48:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52734 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab2CWBsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 21:48:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F6BD60F.8040508@jp.fujitsu.com>
Date: Fri, 23 Mar 2012 10:46:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v6 5/7] mm: remove lru type checks from __isolate_lru_page()
References: <20120322214944.27814.42039.stgit@zurg> <20120322215635.27814.30008.stgit@zurg>
In-Reply-To: <20120322215635.27814.30008.stgit@zurg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/23 6:56), Konstantin Khlebnikov wrote:

> After patch "mm: forbid lumpy-reclaim in shrink_active_list()" we can completely
> remove anon/file and active/inactive lru type filters from __isolate_lru_page(),
> because isolation for 0-order reclaim always isolates pages from right lru list.
> And pages-isolation for lumpy shrink_inactive_list() or memory-compaction anyway
> allowed to isolate pages from all evictable lru lists.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Hugh Dickins <hughd@google.com>
> 

seems reasonable to me.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

