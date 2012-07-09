Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2GICbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:31:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41844 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2GICbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:31:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA4207.4060406@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 11:29:27 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 02/11] mm: swapfile: clean up unuse_pte race handling
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-3-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1341449103-1986-3-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/05 9:44), Johannes Weiner wrote:
> The conditional mem_cgroup_cancel_charge_swapin() is a leftover from
> when the function would continue to reestablish the page even after
> mem_cgroup_try_charge_swapin() failed.  After 85d9fc8 "memcg: fix
> refcnt handling at swapoff", the condition is always true when this
> code is reached.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


