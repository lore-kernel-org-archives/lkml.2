Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab1FFN1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:27:22 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:48292 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1FFN1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eMmJ1+1wJZxRGfX/76Ymp5/XK/W/wn5muKJAHow9XVAvAejdZkntwPscvnej+8n6Zl
         VHwIJAdIkPRDDJGWMQLWe2yea7CbcKxAsV98kixskyNwZXKQShV6rkMDozfunndZs/l9
         9iSU8rrCWtbkrtA3jimMpkJvzUk9gAJl4+/kM=
Date: Mon, 6 Jun 2011 22:27:10 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110606132709.GB1686@barrios-laptop>
References: <20110601233036.GZ19505@random.random>
 <20110602010352.GD7306@suse.de>
 <20110602132954.GC19505@random.random>
 <20110602145019.GG7306@suse.de>
 <20110602153754.GF19505@random.random>
 <20110603020920.GA26753@suse.de>
 <20110603144941.GI7306@suse.de>
 <20110604065853.GA4114@barrios-laptop>
 <20110606104345.GE5247@suse.de>
 <20110606124025.GB12887@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606124025.GB12887@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 02:40:25PM +0200, Andrea Arcangeli wrote:
> On Mon, Jun 06, 2011 at 11:43:45AM +0100, Mel Gorman wrote:
> > Maybe not full, but it has more PageReserved pages than anywhere else
> > and few MIGRATE_MOVABLE blocks. MIGRATE_MOVABLE gets skipped during
> > async compaction we could easily reach the end of the DMA zone quickly.
> 
> Debug data has nr_isolated_file in dma zone 1 and nr_isolated_file in
> normal zone being -1.

It's exactly match with Mel's case.
Thanks for the proving, Andrea.

-- 
Kind regards
Minchan Kim
