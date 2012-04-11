Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2DKGsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:48:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9121 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2DKGsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:48:31 -0400
Date: Wed, 11 Apr 2012 08:48:24 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv24 00/16] Contiguous Memory Allocator
In-reply-to: <CA+K6fF5TbhYX_XYXL33h5s8cnSogSna4Cq2-vM4MfX4igSyozg@mail.gmail.com>
To: "'Sandeep Patil'" <psandeep.s@gmail.com>,
        "'Aaro Koskinen'" <aaro.koskinen@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Benjamin Gaignard'" <benjamin.gaignard@linaro.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Rob Clark'" <rob.clark@linaro.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
Message-id: <00c201cd17af$17a3aa50$46eafef0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac0XPkLQUHP6v98cQkiUkFTkM+ryZwAcBvyg
References: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
 <alpine.DEB.2.00.1204101528390.9354@kernel.research.nokia.com>
 <CA+K6fF5TbhYX_XYXL33h5s8cnSogSna4Cq2-vM4MfX4igSyozg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, April 10, 2012 7:20 PM Sandeep Patil wrote:

> >> This is (yet another) update of CMA patches.
> >
> >
> > How well CMA is supposed to work if you have mlocked processes? I've
> > been testing these patches, and noticed that by creating a small mlocked
> > process you start to get plenty of test_pages_isolated() failure warnings,
> > and bigger allocations will always fail.
> 
> CMIIW, I think mlocked pages are never migrated. The reason is because
> __isolate_lru_pages() does not isolate Unevictable pages right now.
> 
> Minchan added support to allow this but the patch was dropped.
> 
> See the discussion at : https://lkml.org/lkml/2011/8/29/295

Right, we are aware of this limitation. We are working on solving it but we didn't 
consider it a blocker for the core CMA patches. Such issues can be easily fixed with 
the incremental patches.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


