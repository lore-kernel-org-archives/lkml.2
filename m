Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab1KIAGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:06:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44644 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab1KIAGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:06:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Nov 2011 09:05:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 00/10] memcg naturalization -rc5
Message-Id: <20111109090520.e9bf6a4f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1320787408-22866-1-git-send-email-jweiner@redhat.com>
References: <1320787408-22866-1-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Nov 2011 22:23:18 +0100
Johannes Weiner <jweiner@redhat.com> wrote:

> This is version 5 of the memcg naturalization patches.
> 
> They enable traditional page reclaim to find pages from the per-memcg
> LRU lists, thereby getting rid of the double-LRU scheme (per global
> zone in addition to per memcg-zone) and the required extra list head
> per each page in the system.
> 
> The only change from version 4 is using the name `memcg' instead of
> `mem' for memcg pointers in code added in the series.
> 
> This series is based on v3.2-rc1.
> 
> memcg users and distributions are waiting for this because of the
> memory savings.  The changes for regular users that do not create
> memcgs in addition to the root memcg are minimal, and even smaller for
> users that disable the memcg feature at compile time.  Lastly, ongoing
> memcg development, like the breaking up of zone->lru_lock, fixing the
> soft limit implementation/memory guarantees and per-memcg reclaim
> statistics, is already based on this.
> 
> Thanks!

Thank you !.

It seems this series is in -mm now and all memcg patches should be based
on this work.

Note: Everyone, please CC cgroups@vger.kernel.org about cgroup related
changes.

Thanks,
-Kame

