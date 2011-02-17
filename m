Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1BQQO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:14:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36769 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab1BQQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:14:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 18 Feb 2011 01:08:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 4/4] add profile information for invalidated page
Message-Id: <20110218010802.070d51ef.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <7563767d6b6e841a8ac5f8315ee166e0f039723c.1297940291.git.minchan.kim@gmail.com>
References: <cover.1297940291.git.minchan.kim@gmail.com>
	<7563767d6b6e841a8ac5f8315ee166e0f039723c.1297940291.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011 00:08:22 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> This patch adds profile information about invalidated page reclaim.
> It's just for profiling for test so it is never for merging.
> 
> Acked-by: Rik van Riel <riel@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


