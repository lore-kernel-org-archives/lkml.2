Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2HGN0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:26:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2HGN0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:26:22 -0400
Message-ID: <50211778.3030709@redhat.com>
Date: Tue, 07 Aug 2012 09:26:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan@kernel.org>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mm: kswapd: Continue reclaiming for reclaim/compaction
 if the minimum number of pages have not been reclaimed
References: <1344342677-5845-1-git-send-email-mgorman@suse.de> <1344342677-5845-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1344342677-5845-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 08:31 AM, Mel Gorman wrote:
> When direct reclaim is running reclaim/compaction, there is a minimum
> number of pages it reclaims. As it must be under the low watermark to be
> in direct reclaim it has also woken kswapd to do some work. This patch
> has kswapd use the same logic as direct reclaim to reclaim a minimum
> number of pages so compaction can run later.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
