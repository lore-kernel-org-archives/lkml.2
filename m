Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab2HHO7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:59:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375Ab2HHO7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:59:45 -0400
Message-ID: <50227E5C.6070903@redhat.com>
Date: Wed, 08 Aug 2012 10:57:32 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] compaction: fix deferring compaction mistake
References: <1344387464-10037-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1344387464-10037-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 08:57 PM, Minchan Kim wrote:
> [1] fixed bad deferring policy but made mistake about checking
> compact_order_failed in __compact_pgdat so it can't update
> compact_order_failed with new order. It ends up preventing working
> of deffering policy rightly. This patch fixes it.

Good catch.

> [1] aff62249, vmscan: only defer compaction for failed order and higher
>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

