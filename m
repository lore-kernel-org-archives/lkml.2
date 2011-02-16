Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab1BPMEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:04:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758982Ab1BPMEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:04:48 -0500
Date: Wed, 16 Feb 2011 13:03:43 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        Kent Overstreet <kent.overstreet@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: Stop reclaim/compaction earlier due to
 insufficient progress if !__GFP_REPEAT
Message-ID: <20110216120343.GX5935@random.random>
References: <20110209154606.GJ27110@cmpxchg.org>
 <20110209164656.GA1063@csn.ul.ie>
 <20110209182846.GN3347@random.random>
 <20110210102109.GB17873@csn.ul.ie>
 <20110210124838.GU3347@random.random>
 <20110210133323.GH17873@csn.ul.ie>
 <20110210141447.GW3347@random.random>
 <20110210145813.GK17873@csn.ul.ie>
 <20110216095048.GA4473@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216095048.GA4473@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 09:50:49AM +0000, Mel Gorman wrote:
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/vmscan.c |   32 ++++++++++++++++++++++----------
>  1 files changed, 22 insertions(+), 10 deletions(-)

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
