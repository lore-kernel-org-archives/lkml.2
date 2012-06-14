Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab2FNQV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:21:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65273 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab2FNQV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:21:26 -0400
Message-ID: <4FDA0F82.2030708@gmail.com>
Date: Thu, 14 Jun 2012 12:21:22 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Dave Jones <davej@redhat.com>, Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] mm: compaction: add /proc/vmstat entry for rescued
 MIGRATE_UNMOVABLE pageblocks
References: <201206141802.50075.b.zolnierkie@samsung.com>
In-Reply-To: <201206141802.50075.b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/14/12 12:02 PM), Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
> Subject: [PATCH] mm: compaction: add /proc/vmstat entry for rescued MIGRATE_UNMOVABLE pageblocks
>
> compact_rescued_unmovable_blocks shows the number of MIGRATE_UNMOVABLE
> pageblocks converted back to MIGRATE_MOVABLE type by the memory compaction
> code.  Non-zero values indicate that large kernel-originated allocations
> of MIGRATE_UNMOVABLE type happen in the system and need special handling
> from the memory compaction code.
>
> This new vmstat entry is optional but useful for development and understanding
> the system.

This description don't describe why admin need this stat and how to use it.


