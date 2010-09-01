Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0IAHLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:11:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44726 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab0IAHK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:10:57 -0400
Date: Wed, 1 Sep 2010 08:10:43 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] mm: page allocator: Update free page counters
	after pages are placed on the free list
Message-ID: <20100901071042.GD13677@csn.ul.ie>
References: <1283276257-1793-1-git-send-email-mel@csn.ul.ie> <1283276257-1793-2-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1008311317160.867@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008311317160.867@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 01:17:44PM -0500, Christoph Lameter wrote:
> 
> I already did a
> 
> Reviewed-by: Christoph Lameter <cl@linux.com>
> 
> I believe?
> 

You did and I omitted it. It's included now. Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
