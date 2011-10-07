Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1JGUSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:18:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab1JGUSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:18:53 -0400
Date: Fri, 7 Oct 2011 21:18:49 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
        Josh Boyer <jwboyer@redhat.com>, aarcange@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmscan: Limit direct reclaim for higher order
 allocations
Message-ID: <20111007201849.GC6418@suse.de>
References: <1318000643-27996-1-git-send-email-mgorman@suse.de>
 <1318000643-27996-2-git-send-email-mgorman@suse.de>
 <4E8F53CD.9000609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4E8F53CD.9000609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 03:32:29PM -0400, Rik van Riel wrote:
> On 10/07/2011 11:17 AM, Mel Gorman wrote:
> >From: Rik van Riel<riel@redhat.com>
> >
> >When suffering from memory fragmentation due to unfreeable pages,
> >THP page faults will repeatedly try to compact memory.  Due to the
> >unfreeable pages, compaction fails.
> 
> I believe Andrew just merged this one :)
> 

It's not the end of the world, this is not going to be the one mail that
bursts the inbox at the seams :)

-- 
Mel Gorman
SUSE Labs
