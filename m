Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2B1Ajm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:39:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49606 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2B1Ajl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:39:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Feb 2012 09:38:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 09/21] mm: add lruvec->reclaim_stat
Message-Id: <20120228093811.77b5ac09.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120223135224.12988.54332.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120223135224.12988.54332.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 17:52:24 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Merge memcg and non-memcg reclaim stat. We need to update only one.
> Move zone->reclaimer_stat and mem_cgroup_per_zone->reclaimer_stat to struct lruvec.
> 
> struct lruvec will become operating unit for recalimer logic,
> thus this is perfect place for these counters.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

I like this.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

