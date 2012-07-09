Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2GIC5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:57:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40910 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2GIC5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:57:51 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA481E.7010602@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 11:55:26 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 09/11] mm: memcg: split swapin charge function into private
 and public part
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-10-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1341449103-1986-10-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/05 9:45), Johannes Weiner wrote:
> When shmem is charged upon swapin, it does not need to check twice
> whether the memory controller is enabled.
> 
> Also, shmem pages do not have to be checked for everything that
> regular anon pages have to be checked for, so let shmem use the
> internal version directly and allow future patches to move around
> checks that are only required when swapping in anon pages.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


