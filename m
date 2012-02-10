Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750Ab2BJSWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:22:19 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49305 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759375Ab2BJSWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:22:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Fri, 10 Feb 2012 19:10:40 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv19 00/15] Contiguous Memory Allocator
In-reply-to: <20120127162624.40cba14e.akpm@linux-foundation.org>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "'Benjamin Gaignard'" <benjamin.gaignard@linaro.org>
Message-id: <00d901cce81f$4c3edc40$e4bc94c0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AczdU3pAui1fAVAUTbaWWqgIvm1VewKyICnA
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <201201261531.40551.arnd@arndb.de>
 <20120127162624.40cba14e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Saturday, January 28, 2012 1:26 AM Andrew Morton wrote:

> These patches don't seem to have as many acked-bys and reviewed-bys as
> I'd expect.  Given the scope and duration of this, it would be useful
> to gather these up.  But please ensure they are real ones - people
> sometimes like to ack things without showing much sign of having
> actually read them.
> 
> Also there is the supreme tag: "Tested-by:.".  Ohad (at least) has been
> testing the code.  Let's mention that.
> 
> 
> The patches do seem to have been going round in ever-decreasing circles
> lately and I think we have decided to merge them (yes?) so we may as well
> get on and do that and sort out remaining issues in-tree.

It looks that the CMA patch series reached the final version - I've just 
posted version 21 a few minutes ago. Most of the patches got acks from either 
Mel or Arnd and the remaining few needs only minor tweaking, but they affect
only CMA users, which we hope to fix once the series is merged. That's why I
would like to ask You to merge these patches to Your tree and finally give
them a try in linux-next kernel.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



