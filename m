Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2KKTSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 14:18:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2KKTSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 14:18:51 -0500
Date: Sun, 11 Nov 2012 17:18:33 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v12 0/7] make balloon pages movable by compaction
Message-ID: <20121111191832.GA4290@x61.redhat.com>
References: <cover.1352656285.git.aquini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1352656285.git.aquini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 05:01:13PM -0200, Rafael Aquini wrote:
> Change log:
> v12:
>  * Address last suggestions on sorting the barriers usage out      (Mel Gorman);
>  * Fix reported build breakages for CONFIG_BALLOON_COMPACTION=n (Andrew Morton);
>  * Enhance commentary on the locking scheme used for balloon page compaction;
>  * Move all the 'balloon vm_event counter' changes to PATCH 07;

Andrew, 

could you drop the earlier review (v11) and pick this submission (v12) instead,
please?


Aside: before submitting I rebased the series on -next-20121109, after reverting
the v11 commits, to make those clean-up hunks from PATCH 01 apply smoothly.

-- Rafael

