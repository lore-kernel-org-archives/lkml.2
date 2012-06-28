Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab2F1HNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 03:13:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52898 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2F1HNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 03:13:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEC039A.5060506@jp.fujitsu.com>
Date: Thu, 28 Jun 2012 16:11:22 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: akpm@linux-foundation.org, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>, Aaditya Kumar <aaditya.kumar.30@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/2 v2] mm: Factor out memory isolate functions
References: <1340783514-8150-1-git-send-email-minchan@kernel.org> <1340783514-8150-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1340783514-8150-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/27 16:51), Minchan Kim wrote:
> Now mm/page_alloc.c has some memory isolation functions but they
> are used oly when we enable CONFIG_{CMA|MEMORY_HOTPLUG|MEMORY_FAILURE}.
> So let's make it configurable by new CONFIG_MEMORY_ISOLATION so that it
> can reduce binary size and we can check it simple by
> CONFIG_MEMORY_ISOLATION,
> not if defined CONFIG_{CMA|MEMORY_HOTPLUG|MEMORY_FAILURE}.
> 
> This patch is based on next-20120626
> 
> * from v1
>   - rebase on next-20120626
> 
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

