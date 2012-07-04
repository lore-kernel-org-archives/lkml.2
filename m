Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2GDCgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:36:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46737 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab2GDCgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:36:09 -0400
X-AuditID: 9c93016f-b7bccae00000345c-7a-4ff3ac1796b5
Message-ID: <4FF3AC42.2000503@kernel.org>
Date: Wed, 04 Jul 2012 11:36:50 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        jaschut@sandia.gov, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH -mm] mm: minor fixes for compaction
References: <20120628135520.0c48b066@annuminas.surriel.com> <4FECE844.2050803@kernel.org> <20120703161304.7734fbef@annuminas.surriel.com>
In-Reply-To: <20120703161304.7734fbef@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 05:13 AM, Rik van Riel wrote:

> This patch makes the comment for cc->wrapped longer, explaining
> what is really going on. It also incorporates the comment fix
> pointed out by Minchan.
> 
> Additionally, Minchan found that, when no pages get isolated,
> high_pte could be a value that is much lower than desired,
> which might potentially cause compaction to skip a range of
> pages.
> 
> Only assign zone->compact_cache_free_pfn if we actually
> isolated free pages for compaction.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>


Reviewed-by: Minchan Kim <minchan@kernel.org>

> ---
> This does not address the one bit in Minchan's review that I am not sure about...


About this part, let's wait of Mel's opinion.

Thanks.
-- 
Kind regards,
Minchan Kim
