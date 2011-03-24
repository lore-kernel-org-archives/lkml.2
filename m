Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1CXHnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:43:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39865 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1CXHnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:43:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct reclaim path completely
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTimafdn8wPD7Zu3tK4PLgik=-0MeE62nGxq7ks4N@mail.gmail.com>
References: <20110324162936.CC87.A69D9226@jp.fujitsu.com> <AANLkTimafdn8wPD7Zu3tK4PLgik=-0MeE62nGxq7ks4N@mail.gmail.com>
Message-Id: <20110324164307.CC91.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 24 Mar 2011 16:43:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 24, 2011 at 4:28 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> For example, In 4G desktop system.
> >> 32M full scanning and fail to reclaim a page.
> >> It's under 1% coverage.
> >
> > ?? I'm sorry. I haven't catch it.
> > Where 32M come from?
> 
> (1<<12) * 4K + (1<<11) + 4K + .. (1 << 0) + 4K in shrink_zones.

(lru-pages>>12) + (lru-pages>>11) + (lru-pages>>10) ... =~ 2 * lru-page 

?



