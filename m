Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2GIDqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 23:46:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37467 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2GIDqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 23:46:53 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA539E.70805@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 12:44:30 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 11/11] mm: memcg: only check anon swapin page charges
 for swap cache
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-12-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1341449103-1986-12-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/05 9:45), Johannes Weiner wrote:
> shmem knows for sure that the page is in swap cache when attempting to
> charge a page, because the cache charge entry function has a check for
> it.  Only anon pages may be removed from swap cache already when
> trying to charge their swapin.
> 
> Adjust the comment, though: '4969c11 mm: fix swapin race condition'
> added a stable PageSwapCache check under the page lock in the
> do_swap_page() before calling the memory controller, so it's
> unuse_pte()'s pte_same() that may fail.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


