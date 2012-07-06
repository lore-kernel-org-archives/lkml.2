Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2GFBZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 21:25:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:42533 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab2GFBZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 21:25:03 -0400
Message-ID: <1341537867.6330.46.camel@pasglop>
Subject: Re: [PATCH] mm: setup pageblock_order before it's used by sparse
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Xishi Qiu <qiuxishi@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Date: Fri, 06 Jul 2012 11:24:27 +1000
In-Reply-To: <CAE9FiQXAuqj5V_ZrZPs3qr93XQS1tCO=qOBP7mCsDCqXQQ5PoQ@mail.gmail.com>
References: <1341047274-5616-1-git-send-email-jiang.liu@huawei.com>
	 <20120703140705.af23d4d3.akpm@linux-foundation.org>
	 <4FF39F0E.4070300@huawei.com> <20120704092006.GH14154@suse.de>
	 <CAE9FiQXAuqj5V_ZrZPs3qr93XQS1tCO=qOBP7mCsDCqXQQ5PoQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 18:00 -0700, Yinghai Lu wrote:
> cma, dma_continugous_reserve is referring pageblock_order very early
> too.
> just after init_memory_mapping() for x86's setup_arch.
> 
> so set pageblock_order early looks like my -v2 patch is right way.
> 
> current question: need to powerpc guys to check who to set that early.

I missed the beginning of that discussion, I'll try to dig a bit,
might take me til next week though as I'm about to be off for
the week-end.

Cheers,
Ben.


