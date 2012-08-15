Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2HOSwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:52:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab2HOSwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:52:00 -0400
Message-ID: <502BEF53.80200@redhat.com>
Date: Wed, 15 Aug 2012 14:49:55 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Marek Szyprowski <m.szyprowski@samsung.com>, Mel Gorman <mgorman@suse.de>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC 1/2] cma: remove __reclaim_pages
References: <1344934627-8473-1-git-send-email-minchan@kernel.org> <1344934627-8473-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1344934627-8473-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 04:57 AM, Minchan Kim wrote:
> Now cma reclaims too many pages by __reclaim_pages which says
> following as
>
>          * Reclaim enough pages to make sure that contiguous allocation
>          * will not starve the system.
>
> Starve? What does it starve the system? The function which allocate
> free page for migration target would wake up kswapd and do direct reclaim
> if needed during migration so system doesn't starve.
>
> Let remove __reclaim_pages and related function and fields.

Fair enough.

> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Rik van Riel <riel@redhat.com>
