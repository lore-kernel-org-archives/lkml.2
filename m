Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1FFMke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:40:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab1FFMkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:40:33 -0400
Date: Mon, 6 Jun 2011 14:40:25 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>, akpm@linux-foundation.org,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110606124025.GB12887@random.random>
References: <20110601214018.GC7306@suse.de>
 <20110601233036.GZ19505@random.random>
 <20110602010352.GD7306@suse.de>
 <20110602132954.GC19505@random.random>
 <20110602145019.GG7306@suse.de>
 <20110602153754.GF19505@random.random>
 <20110603020920.GA26753@suse.de>
 <20110603144941.GI7306@suse.de>
 <20110604065853.GA4114@barrios-laptop>
 <20110606104345.GE5247@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606104345.GE5247@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:43:45AM +0100, Mel Gorman wrote:
> Maybe not full, but it has more PageReserved pages than anywhere else
> and few MIGRATE_MOVABLE blocks. MIGRATE_MOVABLE gets skipped during
> async compaction we could easily reach the end of the DMA zone quickly.

Debug data has nr_isolated_file in dma zone 1 and nr_isolated_file in
normal zone being -1.
