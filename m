Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2DTMXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 08:23:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50165 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2DTMXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 08:23:03 -0400
Date: Fri, 20 Apr 2012 14:22:55 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv24 00/16] Contiguous Memory Allocator
In-reply-to: <20120419124044.632bfa49.akpm@linux-foundation.org>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "'Benjamin Gaignard'" <benjamin.gaignard@linaro.org>,
        "'Rob Clark'" <rob.clark@linaro.org>,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sandeep Patil'" <psandeep.s@gmail.com>
Message-id: <03b201cd1ef0$50ca9350$f25fb9f0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac0eZFLmHYIDO0PBTqCxcT1bd6hlZAAiuaow
References: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
 <20120419124044.632bfa49.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thursday, April 19, 2012 9:41 PM Andrew Morton wrote:

> On Tue, 03 Apr 2012 16:10:05 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > This is (yet another) update of CMA patches.
> 
> Looks OK to me.  It's a lot of code.
> 
> Please move it into linux-next, and if all is well, ask Linus to pull
> the tree into 3.5-rc1.  Please be sure to cc me on that email.

Ok, thanks! Is it possible to get your acked-by or reviewed-by tag? It
might help a bit to get the pull request accepted by Linus. :)

> I suggest that you include additional patches which enable CMA as much
> as possible on as many architectures as possible so that it gets
> maximum coverage testing in linux-next.  Remove those Kconfig patches
> when merging upstream.
> 
> All this code will probably mess up my tree, but I'll work that out.
> It would be more awkward if the CMA code were to later disappear from
> linux-next or were not merged into 3.5-rc1.  Let's avoid that.

I've put the patches on my dma-mapping-next branch and we will see the
result (and/or complaints) on Monday.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


