Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2GICfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:35:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57261 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2GICfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:35:17 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA42E4.1000003@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 11:33:08 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 03/11] mm: shmem: do not try to uncharge known swapcache
 pages
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1341449103-1986-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/05 9:44), Johannes Weiner wrote:
> Once charged, swapcache pages can only be uncharged after they are
> removed from swapcache again.
> 
> Do not try to uncharge pages that are known to be in the swapcache, to
> allow future patches to remove checks for that in the uncharge code.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


