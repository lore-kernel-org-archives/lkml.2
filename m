Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0FNTZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:25:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab0FNTZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:25:22 -0400
Message-ID: <4C1681ED.5080502@redhat.com>
Date: Mon, 14 Jun 2010 15:24:29 -0400
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
Subject: Re: [PATCH 09/12] vmscan: Setup pagevec as late as possible in shrink_page_list()
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-10-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1276514273-27693-10-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 07:17 AM, Mel Gorman wrote:
> shrink_page_list() sets up a pagevec to release pages as according as they
> are free. It uses significant amounts of stack on the pagevec. This
> patch adds pages to be freed via pagevec to a linked list which is then
> freed en-masse at the end. This avoids using stack in the main path that
> potentially calls writepage().
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
