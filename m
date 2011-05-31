Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1EaUs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:48:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab1EaUs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:48:58 -0400
Message-ID: <4DE5542B.2040700@redhat.com>
Date: Tue, 31 May 2011 16:48:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 01/10] Make clear description of isolate/putback functions
References: <cover.1306689214.git.minchan.kim@gmail.com> <5f9f6c96ccb344c4ca0dd9c1f06bd21db93fda51.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <5f9f6c96ccb344c4ca0dd9c1f06bd21db93fda51.1306689214.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2011 02:13 PM, Minchan Kim wrote:
> Commonly, putback_lru_page is used with isolated_lru_page.
> The isolated_lru_page picks the page in middle of LRU and
> putback_lru_page insert the lru in head of LRU.
> It means it could make LRU churning so we have to be very careful.
> Let's clear description of isolate/putback functions.
>
> Cc: Mel Gorman<mgorman@suse.de>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Andrea Arcangeli<aarcange@redhat.com>
> Reviewed-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Johannes Weiner<hannes@cmpxchg.org>
> Reviewed-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
