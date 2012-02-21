Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2BUIHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 03:07:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45498 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2BUIHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 03:07:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Feb 2012 17:05:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/10] mm/memcg: move reclaim_stat into lruvec
Message-Id: <20120221170538.84461d91.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1202201528280.23274@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils>
	<alpine.LSU.2.00.1202201528280.23274@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 15:29:37 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> With mem_cgroup_disabled() now explicit, it becomes clear that the
> zone_reclaim_stat structure actually belongs in lruvec, per-zone
> when memcg is disabled but per-memcg per-zone when it's enabled.
> 
> We can delete mem_cgroup_get_reclaim_stat(), and change
> update_page_reclaim_stat() to update just the one set of stats,
> the one which get_scan_count() will actually use.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Seems nice to me.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

