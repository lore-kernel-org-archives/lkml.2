Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0FNU57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab0FNU56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:57:58 -0400
Subject: Re: [PATCH 02/12] tracing, vmscan: Add trace events for LRU page
	isolation
From: Larry Woodman <lwoodman@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1276514273-27693-3-git-send-email-mel@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	 <1276514273-27693-3-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 17:02:10 -0400
Message-Id: <1276549330.8736.104.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 12:17 +0100, Mel Gorman wrote:
> This patch adds an event for when pages are isolated en-masse from the
> LRU lists. This event augments the information available on LRU traffic
> and can be used to evaluate lumpy reclaim.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Larry Woodman <lwoodman@redhat.com>


