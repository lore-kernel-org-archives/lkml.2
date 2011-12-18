Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab1LRAtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 19:49:24 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57408 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1LRAtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:49:22 -0500
MIME-Version: 1.0
In-Reply-To: <1323875693-3504-1-git-send-email-tm@tao.ma>
References: <20111213164507.fbee477c.akpm@linux-foundation.org>
	<1323875693-3504-1-git-send-email-tm@tao.ma>
Date: Sun, 18 Dec 2011 09:49:20 +0900
Message-ID: <CAEwNFnBrczRf6XMeN6EaTkANVPdzLeAXqahJxAWPGz3GDW5nWg@mail.gmail.com>
Subject: Re: [PATCH v3] vmscan/trace: Add 'file' info to trace_mm_vmscan_lru_isolate.
From: Minchan Kim <minchan.kim@gmail.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 12:14 AM, Tao Ma <tm@tao.ma> wrote:
> From: Tao Ma <boyu.mt@taobao.com>
>
> In trace_mm_vmscan_lru_isolate, we don't output 'file'
> information to the trace event and it is a bit inconvenient for the
> user to get the real information(like pasted below).
> mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
> nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
>
> 'active' can be gotten by analyzing mode(Thanks go to Minchan and Mel),
> So this patch adds 'file' to the trace event and it now looks like:
> mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
> nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0 file=0
>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Andrew pointed out that   trace_mm_vmscan_memcg_isolate is out , Otherwise,
Reviewed-by: Minchan Kim <minchan@kernel.org>


-- 
Kind regards,
Minchan Kim
