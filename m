Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0G1LTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 07:19:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60463 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0G1LTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 07:19:48 -0400
Date: Wed, 28 Jul 2010 12:19:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 3/9] vmscan: tracing: Update post-processing script to
	distinguish between anon and file IO from page reclaim
Message-ID: <20100728111932.GG5300@csn.ul.ie>
References: <1280312843-11789-1-git-send-email-mel@csn.ul.ie> <1280312843-11789-4-git-send-email-mel@csn.ul.ie> <20100728110507.GA31360@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100728110507.GA31360@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 07:05:07AM -0400, Christoph Hellwig wrote:
> Just wondering if you ever looked into the perf perl scripting support?
> Making this a directly accesible command in perf would be quite nice.
> 

I'm aware of the possibility and have a long-standing TODO item to convert
both post-processing scripts into sensible perf equivalents.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
