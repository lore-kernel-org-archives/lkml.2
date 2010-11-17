Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0KQXsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:48:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915Ab0KQXsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:48:15 -0500
Date: Wed, 17 Nov 2010 15:46:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Use memory compaction instead of lumpy reclaim
 during high-order allocations
Message-Id: <20101117154641.51fd7ce5.akpm@linux-foundation.org>
In-Reply-To: <1290010969-26721-1-git-send-email-mel@csn.ul.ie>
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 16:22:41 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> Huge page allocations are not expected to be cheap but lumpy reclaim
> is still very disruptive.

Huge pages are boring.  Can we expect any benefit for the
stupid-nic-driver-which-does-order-4-GFP_ATOMIC-allocations problem?

>
> ...
>
> I haven't pushed hard on the concept of lumpy compaction yet and right
> now I don't intend to during this cycle. The initial prototypes did not
> behave as well as expected and this series improves the current situation
> a lot without introducing new algorithms. Hence, I'd like this series to
> be considered for merging.

Translation: "Andrew, wait for the next version"? :)

> I'm hoping that this series also removes the
> necessity for the "delete lumpy reclaim" patch from the THP tree.

Now I'm sad.  I read all that and was thinking "oh goody, we get to
delete something for once".  But no :(

If you can get this stuff to work nicely, why can't we remove lumpy
reclaim?
