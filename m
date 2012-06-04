Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2FDRNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab2FDRNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:13:47 -0400
Date: Mon, 4 Jun 2012 13:13:28 -0400
From: Dave Jones <davej@redhat.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH v9] mm: compaction: handle incorrect MIGRATE_UNMOVABLE
 type pageblocks
Message-ID: <20120604171328.GA23788@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <amwang@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
References: <201206041543.56917.b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206041543.56917.b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 03:43:56PM +0200, Bartlomiej Zolnierkiewicz wrote:
 > 
 > Dave, could you please test this version?
 > 
 > From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
 > Subject: [PATCH v9] mm: compaction: handle incorrect MIGRATE_UNMOVABLE type pageblocks

Initial testing looks good.

	Dave

