Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab2FVUM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:12:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab2FVUM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:12:56 -0400
Date: Fri, 22 Jun 2012 13:12:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>, Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] mm: compaction: add /proc/vmstat entry for rescued
 MIGRATE_UNMOVABLE pageblocks
Message-Id: <20120622131254.cc606c00.akpm@linux-foundation.org>
In-Reply-To: <4FDA0F82.2030708@gmail.com>
References: <201206141802.50075.b.zolnierkie@samsung.com>
	<4FDA0F82.2030708@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 12:21:22 -0400
KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> (6/14/12 12:02 PM), Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz<b.zolnierkie@samsung.com>
> > Subject: [PATCH] mm: compaction: add /proc/vmstat entry for rescued MIGRATE_UNMOVABLE pageblocks
> >
> > compact_rescued_unmovable_blocks shows the number of MIGRATE_UNMOVABLE
> > pageblocks converted back to MIGRATE_MOVABLE type by the memory compaction
> > code.  Non-zero values indicate that large kernel-originated allocations
> > of MIGRATE_UNMOVABLE type happen in the system and need special handling
> > from the memory compaction code.
> >
> > This new vmstat entry is optional but useful for development and understanding
> > the system.
> 
> This description don't describe why admin need this stat and how to use it.
> 

Was there a response to this?

patch [1/2] doesn't apply.  Refresh and resend the series, please?
