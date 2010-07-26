Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0GZLLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 07:11:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59733 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0GZLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 07:11:42 -0400
Date: Mon, 26 Jul 2010 12:11:26 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] vmscan: convert mm_vmscan_lru_isolate to
	DEFINE_EVENT
Message-ID: <20100726111126.GP5300@csn.ul.ie>
References: <20100726120107.2EEE.A69D9226@jp.fujitsu.com> <20100726120422.2EF7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100726120422.2EF7.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 12:05:13PM +0900, KOSAKI Motohiro wrote:
> Mel Gorman recently added some vmscan tracepoints. Unfortunately
> they are covered only global reclaim. But we want to trace memcg
> reclaim too.
> 
> Thus, this patch convert them to DEFINE_TRACE macro. it help to
> reuse tracepoint definition for other similar usage (i.e. memcg).
> This patch have no functionally change.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
