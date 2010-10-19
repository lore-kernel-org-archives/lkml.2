Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0JSA7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:59:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59988 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab0JSA7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:59:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 19 Oct 2010 09:53:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 07/11] memcg: add dirty limits to mem_cgroup
Message-Id: <20101019095347.473286af.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287448784-25684-8-git-send-email-gthelen@google.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-8-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 17:39:40 -0700
Greg Thelen <gthelen@google.com> wrote:

> Extend mem_cgroup to contain dirty page limits.  Also add routines
> allowing the kernel to query the dirty usage of a memcg.
> 
> These interfaces not used by the kernel yet.  A subsequent commit
> will add kernel calls to utilize these new routines.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> ---
> 
> Changelog since v1:
> - Rename (for clarity):
>   - mem_cgroup_write_page_stat_item -> mem_cgroup_page_stat_item
>   - mem_cgroup_read_page_stat_item -> mem_cgroup_nr_pages_item
> - Removed unnecessary get_ prefix from get_xxx() functions.
> - Avoid lockdep warnings by using rcu_read_[un]lock() in
>   mem_cgroup_has_dirty_limit().
> 

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

