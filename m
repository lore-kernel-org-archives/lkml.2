Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab0FNSGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:06:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab0FNSGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:06:19 -0400
Message-ID: <4C166F2E.4030606@redhat.com>
Date: Mon, 14 Jun 2010 14:04:30 -0400
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
Subject: Re: [PATCH 05/12] vmscan: kill prev_priority completely
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-6-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1276514273-27693-6-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 07:17 AM, Mel Gorman wrote:
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>
> Since 2.6.28 zone->prev_priority is unused. Then it can be removed
> safely. It reduce stack usage slightly.
>
> Now I have to say that I'm sorry. 2 years ago, I thought prev_priority
> can be integrate again, it's useful. but four (or more) times trying
> haven't got good performance number. Thus I give up such approach.
>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Johannes Weiner<hannes@cmpxchg.org>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
