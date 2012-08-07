Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2HGNTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab2HGNTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:19:36 -0400
Message-ID: <502115DB.105@redhat.com>
Date: Tue, 07 Aug 2012 09:19:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan@kernel.org>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] mm: compaction: Update comment in try_to_compact_pages
References: <1344342677-5845-1-git-send-email-mgorman@suse.de> <1344342677-5845-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1344342677-5845-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 08:31 AM, Mel Gorman wrote:
> The comment about order applied when the check was
> order>  PAGE_ALLOC_COSTLY_ORDER which has not been the case since
> [c5a73c3d: thp: use compaction for all allocation orders]. Fixing
> the comment while I'm in the general area.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
