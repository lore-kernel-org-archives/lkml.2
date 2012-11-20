Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab2KTTwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:52:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2KTTwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:52:23 -0500
Date: Tue, 20 Nov 2012 11:52:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Kyungmin Park <kyungmin.park@samsung.com>, Soren Moch <smoch@web.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-Id: <20121120115222.9b674d86.akpm@linux-foundation.org>
In-Reply-To: <50AB600C.5010801@samsung.com>
References: <1352356737-14413-1-git-send-email-m.szyprowski@samsung.com>
	<20121119001846.GB22106@titan.lakedaemon.net>
	<20121119144826.f59667b2.akpm@linux-foundation.org>
	<50AB600C.5010801@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 11:48:44 +0100
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> > As this patch is already in -next and is stuck there for two more
> > weeks I can't (or at least won't) merge this patch, so I can't help
> > with any of the above.
> 
> I will fix both issues in the next version of the patch. Would like to
> merge it to your tree or should I keep it in my dma-mapping tree?

The patch looks OK to me now (still wondering about the -stable
question though).

It would be a bit of a pain for me to carry a patch which conflicts
with one in linux-next, and this patch doesn't appear to conflict with
the other pending dmapool.c patches in -mm so you may as well keep it
in the dma-mapping tree now.

