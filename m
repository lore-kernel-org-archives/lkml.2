Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab2HNOYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:24:43 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:2895 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab2HNOY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:24:26 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2012 10:24:26 EDT
Date: Tue, 14 Aug 2012 14:14:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Hanjun Guo <guohanjun@huawei.com>
cc: Wu Jianguo <wujianguo@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tony Luck <tony.luck@intel.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC PATCH] mm: introduce N_LRU_MEMORY to distinguish between
 normal and movable memory
In-Reply-To: <502A3CD2.9000007@huawei.com>
Message-ID: <00000139257cb4f7-55034aa0-7541-498a-9a3f-259435ccec65-000000@email.amazonses.com>
References: <1344482788-4984-1-git-send-email-guohanjun@huawei.com> <50233EF5.3050605@huawei.com> <alpine.DEB.2.02.1208090900450.15909@greybox.home> <5024CADC.1010202@huawei.com> <alpine.DEB.2.02.1208100909410.3903@greybox.home>
 <502A3CD2.9000007@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, Hanjun Guo wrote:

> N_NORMAL_MEMORY means !LRU allocs possible.

Ok. I am fine with that change. However this is a significant change that
needs to be mentioned prominently in the changelog and there need to be
some comments explaining the meaning of these flags clearly in the source.

