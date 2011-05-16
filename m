Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1EPKfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:35:50 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58476 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab1EPKft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:35:49 -0400
Date: Mon, 16 May 2011 16:00:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 0/6] mm: memcg naturalization
Message-ID: <20110516103034.GI22412@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Johannes Weiner <hannes@cmpxchg.org> [2011-05-12 16:53:52]:

> Hi!
> 
> Here is a patch series that is a result of the memcg discussions on
> LSF (memcg-aware global reclaim, global lru removal, struct
> page_cgroup reduction, soft limit implementation) and the recent
> feature discussions on linux-mm.
> 
> The long-term idea is to have memcgs no longer bolted to the side of
> the mm code, but integrate it as much as possible such that there is a
> native understanding of containers, and that the traditional !memcg
> setup is just a singular group.  This series is an approach in that
> direction.
> 
> It is a rather early snapshot, WIP, barely tested etc., but I wanted
> to get your opinions before further pursuing it.  It is also part of
> my counter-argument to the proposals of adding memcg-reclaim-related
> user interfaces at this point in time, so I wanted to push this out
> the door before things are merged into .40.
> 
> The patches are quite big, I am still looking for things to factor and
> split out, sorry for this.  Documentation is on its way as well ;)
> 
> #1 and #2 are boring preparational work.  #3 makes traditional reclaim
> in vmscan.c memcg-aware, which is a prerequisite for both removal of
> the global lru in #5 and the way I reimplemented soft limit reclaim in
> #6.

A large part of the acceptance would be based on what the test results
for common mm benchmarks show.

-- 
	Three Cheers,
	Balbir
