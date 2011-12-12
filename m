Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1LLCsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 21:48:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38074 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1LLCsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 21:48:52 -0500
MIME-Version: 1.0
In-Reply-To: <1323614784-2924-1-git-send-email-tm@tao.ma>
References: <1323614784-2924-1-git-send-email-tm@tao.ma>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sun, 11 Dec 2011 21:48:31 -0500
X-Google-Sender-Auth: JV6Rq6s2_03OJnaQbgvcJx3JoxU
Message-ID: <CAHGf_=oLm3euUt3drzF1v77mVRsAKbYcrd0rWGD_zOu1Q_G6Ew@mail.gmail.com>
Subject: Re: [PATCH V2] vmscan/trace: Add 'active' and 'file' info to trace_mm_vmscan_lru_isolate.
To: Tao Ma <tm@tao.ma>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Tao Ma <boyu.mt@taobao.com>
>
> In trace_mm_vmscan_lru_isolate, we don't output 'active' and 'file'
> information to the trace event and it is a bit inconvenient for the
> user to get the real information(like pasted below).
> mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
> nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
>
> So this patch adds these 2 info to the trace event and it now looks like:
> mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
> nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0 active=1 file=0

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
