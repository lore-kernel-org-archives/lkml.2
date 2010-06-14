Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0FNU4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab0FNU4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:56:50 -0400
Subject: Re: [PATCH 01/12] tracing, vmscan: Add trace events for kswapd
	wakeup, sleeping and direct reclaim
From: Larry Woodman <lwoodman@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1276514273-27693-2-git-send-email-mel@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	 <1276514273-27693-2-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 17:01:04 -0400
Message-Id: <1276549264.8736.101.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 12:17 +0100, Mel Gorman wrote:
> This patch adds two trace events for kswapd waking up and going asleep for
> the purposes of tracking kswapd activity and two trace events for direct
> reclaim beginning and ending. The information can be used to work out how
> much time a process or the system is spending on the reclamation of pages
> and in the case of direct reclaim, how many pages were reclaimed for that
> process.  High frequency triggering of these events could point to memory
> pressure problems.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Larry Woodman <lwoodman@redhat.com>


