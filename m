Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1GFWMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:12:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568Ab1GFWMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:12:21 -0400
Date: Wed, 6 Jul 2011 15:11:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunsang Jeong <chunsang.jeong@linaro.org>
Subject: Re: [PATCHv11 0/8] Contiguous Memory Allocator
Message-Id: <20110706151112.5c619431.akpm@linux-foundation.org>
In-Reply-To: <201107051407.17249.arnd@arndb.de>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com>
	<201107051407.17249.arnd@arndb.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011 14:07:17 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 05 July 2011, Marek Szyprowski wrote:
> > This is yet another round of Contiguous Memory Allocator patches. I hope
> > that I've managed to resolve all the items discussed during the Memory
> > Management summit at Linaro Meeting in Budapest and pointed later on
> > mailing lists. The goal is to integrate it as tight as possible with
> > other kernel subsystems (like memory management and dma-mapping) and
> > finally merge to mainline.
> 
> You have certainly addressed all of my concerns, this looks really good now!
> 
> Andrew, can you add this to your -mm tree? What's your opinion on the
> current state, do you think this is ready for merging in 3.1 or would
> you want to have more reviews from core memory management people?
> 
> My reviews were mostly on the driver and platform API side, and I think
> we're fine there now, but I don't really understand the impacts this has
> in mm.

I could review it and put it in there on a preliminary basis for some
runtime testing.  But the question in my mind is how different will the
code be after the problems which rmk has identified have been fixed?

If "not very different" then that effort and testing will have been
worthwhile.

If "very different" or "unworkable" then it was all for naught.

So.  Do we have a feeling for the magnitude of the changes which will
be needed to fix these things up?

