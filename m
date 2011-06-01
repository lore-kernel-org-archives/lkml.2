Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab1FAVIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758921Ab1FAVIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:08:36 -0400
Message-ID: <4DE6AA49.4090907@redhat.com>
Date: Wed, 01 Jun 2011 17:08:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 07/10] In order putback lru core
References: <cover.1306689214.git.minchan.kim@gmail.com> <e473fa18da363dfdfbd43e1862e48563f6d4e36f.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <e473fa18da363dfdfbd43e1862e48563f6d4e36f.1306689214.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2011 02:13 PM, Minchan Kim wrote:
> This patch defines new APIs to put back the page into previous position of LRU.
> The idea I suggested in LSF/MM is simple.
>
> When we try to put back the page into lru list and if friends(prev, next) of the page
> still is nearest neighbor, we can insert isolated page into prev's next instead of
> head of LRU list. So it keeps LRU history without losing the LRU information.

> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman<mgorman@suse.de>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Andrea Arcangeli<aarcange@redhat.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Looks reasonable.

Acked-by: Rik van Riel <riel@redhat.com>
