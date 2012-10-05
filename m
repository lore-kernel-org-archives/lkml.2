Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2JEVpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:45:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60005 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2JEVpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:45:11 -0400
Date: Fri, 05 Oct 2012 17:45:08 -0400 (EDT)
Message-Id: <20121005.174508.1624534294642226949.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        aarcange@redhat.com, hannes@cmpxchg.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org
Subject: Re: [PATCH v2 0/8] THP support for Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121005143644.abb14c2b.akpm@linux-foundation.org>
References: <20121004.154624.923241475790311926.davem@davemloft.net>
	<20121005143644.abb14c2b.akpm@linux-foundation.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 5 Oct 2012 14:36:44 -0700

> David, I don't know what to do until there's some clarity on the
> numa/sched changes.  Andrea has a new autonuma patchset, Peter's code
> is in -next and I don't know if it's planned for 3.7 merging.  And I
> suspect (hope) that it won't be merged if that is indeed planned.

It doesn't matter from a sparc64 perspective.

If you remove the autonuma patch, I'll still compile and work.
I just provide an unused interface. 

Please do something instead of stalling these changes further.

Thanks.
