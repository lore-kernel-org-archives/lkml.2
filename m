Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1IMKrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:47:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50795 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1IMKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:47:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Sep 2011 19:47:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 10/11] mm: make per-memcg LRU lists exclusive
Message-Id: <20110913194704.783d0547.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1315825048-3437-11-git-send-email-jweiner@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
	<1315825048-3437-11-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011 12:57:27 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> Now that all code that operated on global per-zone LRU lists is
> converted to operate on per-memory cgroup LRU lists instead, there is
> no reason to keep the double-LRU scheme around any longer.
> 
> The pc->lru member is removed and page->lru is linked directly to the
> per-memory cgroup LRU lists, which removes two pointers from a
> descriptor that exists for every page frame in the system.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Ying Han <yinghan@google.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

