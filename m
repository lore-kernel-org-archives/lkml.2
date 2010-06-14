Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab0FNU7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:59:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0FNU72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:59:28 -0400
Subject: Re: [PATCH 04/12] tracing, vmscan: Add a postprocessing script for
	reclaim-related ftrace events
From: Larry Woodman <lwoodman@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1276514273-27693-5-git-send-email-mel@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	 <1276514273-27693-5-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 17:03:44 -0400
Message-Id: <1276549425.8736.107.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 12:17 +0100, Mel Gorman wrote:
> This patch adds a simple post-processing script for the reclaim-related
> trace events.  It can be used to give an indication of how much traffic
> there is on the LRU lists and how severe latencies due to reclaim are.

Acked-by: Larry Woodman <lwoodman@redhat.com>


