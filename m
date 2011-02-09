Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1BIXtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:49:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35499 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab1BIXtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:49:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Feb 2011 08:42:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch] memcg: charged pages always have valid per-memcg zone
 info
Message-Id: <20110210084258.55e158fe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1297248275-23521-1-git-send-email-hannes@cmpxchg.org>
References: <1297248275-23521-1-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Feb 2011 11:44:35 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> page_cgroup_zoneinfo() will never return NULL for a charged page,
> remove the check for it in mem_cgroup_get_reclaim_stat_from_page().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

IIUC, this _was_ required when force_empty() had troubles.
But now, not required.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

