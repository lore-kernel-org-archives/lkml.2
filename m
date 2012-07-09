Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2GICv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:51:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60004 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2GICv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:51:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA46A4.20309@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 11:49:08 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11] mm: memcg: only check for PageSwapCache when uncharging
 anon
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-6-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1341449103-1986-6-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/05 9:44), Johannes Weiner wrote:
> Only anon pages that are uncharged at the time of the last page table
> mapping vanishing may be in swapcache.
> 
> When shmem pages, file pages, swap-freed anon pages, or just migrated
> pages are uncharged, they are known for sure to be not in swapcache.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


