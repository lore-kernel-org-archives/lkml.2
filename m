Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab2BNH6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:58:03 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47752 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab2BNH56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:57:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Feb 2012 16:56:16 +0900
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
Subject: Re: [PATCHv21 07/16] mm: page_alloc: change fallbacks array
 handling
Message-Id: <20120214165616.8b8e36f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1328895151-5196-8-git-send-email-m.szyprowski@samsung.com>
References: <1328895151-5196-1-git-send-email-m.szyprowski@samsung.com>
	<1328895151-5196-8-git-send-email-m.szyprowski@samsung.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012 18:32:22 +0100
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> This commit adds a row for MIGRATE_ISOLATE type to the fallbacks array
> which was missing from it.  It also, changes the array traversal logic
> a little making MIGRATE_RESERVE an end marker.  The letter change,
> removes the implicit MIGRATE_UNMOVABLE from the end of each row which
> was read by __rmqueue_fallback() function.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Tested-by: Rob Clark <rob.clark@linaro.org>
> Tested-by: Ohad Ben-Cohen <ohad@wizery.com>
> Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

