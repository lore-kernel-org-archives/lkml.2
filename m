Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0LAKe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:34:28 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:43000 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab0LAKe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:34:26 -0500
Date: Wed, 1 Dec 2010 11:34:11 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] mm: vmscan: Rename lumpy_mode to reclaim_mode
Message-ID: <20101201103411.GP15564@cmpxchg.org>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
 <1290440635-30071-8-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290440635-30071-8-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 03:43:55PM +0000, Mel Gorman wrote:
> With compaction being used instead of lumpy reclaim, the name lumpy_mode
> and associated variables is a bit misleading. Rename lumpy_mode to
> reclaim_mode which is a better fit. There is no functional change.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
