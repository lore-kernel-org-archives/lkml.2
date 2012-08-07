Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab2HGNXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab2HGNXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:23:45 -0400
Message-ID: <502116DA.4040409@redhat.com>
Date: Tue, 07 Aug 2012 09:23:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan@kernel.org>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm: vmscan: Scale number of pages reclaimed by reclaim/compaction
 based on failures
References: <1344342677-5845-1-git-send-email-mgorman@suse.de> <1344342677-5845-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1344342677-5845-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 08:31 AM, Mel Gorman wrote:
> If allocation fails after compaction then compaction may be deferred for
> a number of allocation attempts. If there are subsequent failures,
> compact_defer_shift is increased to defer for longer periods. This patch
> uses that information to scale the number of pages reclaimed with
> compact_defer_shift until allocations succeed again.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
