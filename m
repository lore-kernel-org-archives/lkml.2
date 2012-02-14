Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab2BNHtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:49:03 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54704 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2BNHs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:48:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Feb 2012 16:47:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCHv21 05/16] mm: compaction: export some of the functions
Message-Id: <20120214164716.371623c0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1328895151-5196-6-git-send-email-m.szyprowski@samsung.com>
References: <1328895151-5196-1-git-send-email-m.szyprowski@samsung.com>
	<1328895151-5196-6-git-send-email-m.szyprowski@samsung.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012 18:32:20 +0100
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> This commit exports some of the functions from compaction.c file
> outside of it adding their declaration into internal.h header
> file so that other mm related code can use them.
> 
> This forced compaction.c to always be compiled (as opposed to being
> compiled only if CONFIG_COMPACTION is defined) but as to avoid
> introducing code that user did not ask for, part of the compaction.c
> is now wrapped in on #ifdef.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Tested-by: Rob Clark <rob.clark@linaro.org>
> Tested-by: Ohad Ben-Cohen <ohad@wizery.com>
> Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Reivewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Onto linux-next(Feb13), becasue of a patch
" mm: compaction: make compact_control order signed", 
 (41f0810873917dc3a05ec955651f6d7edf1e8946)

compaction_control.order should be changed to be signed.


