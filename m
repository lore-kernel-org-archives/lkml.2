Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824Ab1LOXgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:36:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759670Ab1LOXgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:36:49 -0500
Message-ID: <4EEA8470.9040907@redhat.com>
Date: Thu, 15 Dec 2011 18:36:16 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/11] mm: vmscan: Do not OOM if aborting reclaim to start
 compaction
References: <1323877293-15401-1-git-send-email-mgorman@suse.de> <1323877293-15401-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1323877293-15401-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 10:41 AM, Mel Gorman wrote:
> During direct reclaim it is possible that reclaim will be aborted so
> that compaction can be attempted to satisfy a high-order allocation. If
> this decision is made before any pages are reclaimed, it is possible
> that 0 is returned to the page allocator potentially triggering an
> OOM. This has not been observed but it is a possibility so this patch
> addresses it.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
