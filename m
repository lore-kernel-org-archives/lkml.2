Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0FNToO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:44:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab0FNToM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:44:12 -0400
Message-ID: <4C168640.6080309@redhat.com>
Date: Mon, 14 Jun 2010 15:42:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/12] vmscan: Update isolated page counters outside of
 main path in shrink_inactive_list()
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-11-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1276514273-27693-11-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 07:17 AM, Mel Gorman wrote:
> When shrink_inactive_list() isolates pages, it updates a number of
> counters using temporary variables to gather them. These consume stack
> and it's in the main path that calls ->writepage(). This patch moves the
> accounting updates outside of the main path to reduce stack usage.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>
> Reviewed-by: Johannes Weiner<hannes@cmpxchg.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
