Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab2HWRhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:37:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab2HWRh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:37:28 -0400
Message-ID: <50366A64.8030203@redhat.com>
Date: Thu, 23 Aug 2012 13:37:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH 1/5] vmscan: Fix obsolete comment of balance_pgdat
References: <1345619717-5322-1-git-send-email-minchan@kernel.org> <1345619717-5322-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1345619717-5322-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 03:15 AM, Minchan Kim wrote:
> This patch correct obsolete comment caused by [1] and [2].
>
> [1] 7ac6218, kswapd lockup fix
> [2] 32a4330, mm: prevent kswapd from freeing excessive amounts of lowmem
>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Rik van Riel <riel@redhat.com>
