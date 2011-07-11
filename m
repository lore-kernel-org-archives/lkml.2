Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab1GKNYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:24:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18044 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1GKNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:24:15 -0400
Date: Mon, 11 Jul 2011 15:24:08 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv11 0/8] Contiguous Memory Allocator
In-reply-to: <20110706151112.5c619431.akpm@linux-foundation.org>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>
Message-id: <001d01cc3fcd$d082a450$7187ecf0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Acw8Kccvk8Cck2sxSn2iDxXNu+oLSgDor6gQ
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com>
 <201107051407.17249.arnd@arndb.de>
 <20110706151112.5c619431.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, July 07, 2011 12:11 AM Andrew Morton wrote:

> On Tue, 5 Jul 2011 14:07:17 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Tuesday 05 July 2011, Marek Szyprowski wrote:
> > > This is yet another round of Contiguous Memory Allocator patches. I
> hope
> > > that I've managed to resolve all the items discussed during the Memory
> > > Management summit at Linaro Meeting in Budapest and pointed later on
> > > mailing lists. The goal is to integrate it as tight as possible with
> > > other kernel subsystems (like memory management and dma-mapping) and
> > > finally merge to mainline.
> >
> > You have certainly addressed all of my concerns, this looks really good
> now!
> >
> > Andrew, can you add this to your -mm tree? What's your opinion on the
> > current state, do you think this is ready for merging in 3.1 or would
> > you want to have more reviews from core memory management people?
> >
> > My reviews were mostly on the driver and platform API side, and I think
> > we're fine there now, but I don't really understand the impacts this has
> > in mm.
> 
> I could review it and put it in there on a preliminary basis for some
> runtime testing.  But the question in my mind is how different will the
> code be after the problems which rmk has identified have been fixed?
> 
> If "not very different" then that effort and testing will have been
> worthwhile.

The issue reported by Russell is very ARM specific and can be solved mostly
in arch/arm/mm/dma-mapping.c, maybe with some minor changes/helpers in
drivers/base/dma-contiguous.c The core part in linux/mm probably won't be
affected by these changes at all.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



