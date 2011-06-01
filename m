Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161438Ab1FAJZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:25:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:47510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161423Ab1FAJYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 05:24:54 -0400
Date: Wed, 1 Jun 2011 10:24:47 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, akpm@linux-foundation.org,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110601092447.GA7306@suse.de>
References: <20110530131300.GQ5044@csn.ul.ie>
 <20110530143109.GH19505@random.random>
 <20110530153748.GS5044@csn.ul.ie>
 <20110530165546.GC5118@suse.de>
 <20110530175334.GI19505@random.random>
 <20110531121620.GA3490@barrios-laptop>
 <20110531122437.GJ19505@random.random>
 <20110531133340.GB3490@barrios-laptop>
 <20110531141402.GK19505@random.random>
 <20110601005747.GC7019@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110601005747.GC7019@csn.ul.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 01:57:47AM +0100, Mel Gorman wrote:
> It's almost 2am so I'm wiped but the first thing in the morning
> I want to check is if http://lkml.org/lkml/2010/8/26/32 is
> relevant.

It's not. The patch I really meant was
https://lkml.org/lkml/2011/5/28/155 and it's irrelevant to 2.6.38.4
which is already doing the right thing of rechecking page->mapping under
lock.

-- 
Mel Gorman
SUSE Labs
