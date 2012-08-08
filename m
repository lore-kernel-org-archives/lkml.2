Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab2HHJ6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:58:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab2HHJ6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:58:08 -0400
Date: Wed, 8 Aug 2012 10:58:03 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mm: kswapd: Continue reclaiming for
 reclaim/compaction if the minimum number of pages have not been reclaimed
Message-ID: <20120808095803.GL29814@suse.de>
References: <1344342677-5845-1-git-send-email-mgorman@suse.de>
 <1344342677-5845-4-git-send-email-mgorman@suse.de>
 <20120808020749.GC4247@bbox>
 <20120808090757.GK29814@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120808090757.GK29814@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 10:07:57AM +0100, Mel Gorman wrote:
> > <SNIP>
> 
> It was intentional at the time but asking me about it made me reconsider,
> thanks. In too many cases, this is a no-op and any apparent increase of
> kswapd activity is likely a co-incidence. This is untested but is what I
> intended.
> 
> ---8<---
> mm: kswapd: Continue reclaiming for reclaim/compaction if the minimum number of pages have not been reclaimed
> 

And considering this further again, it would partially regress fe2c2a10
and be too aggressive. I'm dropping this patch completely for now and will
revisit it in the future.

Thanks Minchan.

-- 
Mel Gorman
SUSE Labs
