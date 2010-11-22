Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab0KVQCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:02:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab0KVQCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:02:35 -0500
Date: Mon, 22 Nov 2010 17:01:56 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Use memory compaction instead of lumpy reclaim
 during high-order allocations V2
Message-ID: <20101122160156.GE6118@random.random>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

this looks great to me. I'll replace my patch 1/66 with this patchset
to test with THP. It shall work fine.

Thanks,
Andrea
