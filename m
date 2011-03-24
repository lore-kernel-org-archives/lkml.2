Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1CXCsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:48:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51636 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab1CXCsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:48:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct reclaim path completely
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20110323192150.9895afe3.akpm@linux-foundation.org>
References: <20110324111200.1AF4.A69D9226@jp.fujitsu.com> <20110323192150.9895afe3.akpm@linux-foundation.org>
Message-Id: <20110324114842.CC70.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 24 Mar 2011 11:48:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Mar 2011 11:11:46 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Subject: [PATCH] vmscan: remove all_unreclaimable check from direct reclaim path completely
> 
> zone.all_unreclaimable is there to prevent reclaim from wasting CPU
> cycles scanning a zone which has no reclaimable pages.  When originally
> implemented it did this very well.
>
> That you guys keep breaking it, or don't feel like improving it is not a
> reason to remove it!
> 
> If the code is unneeded and the kernel now reliably solves this problem
> by other means then this should have been fully explained in the
> changelog, but it was not even mentioned.

The changelog says, the logic was removed at 2008. three years ago.
even though it's unintentionally. and I and minchan tried to resurrect
the broken logic and resurrected a bug in the logic too. then, we
are discussed it should die or alive.

Which part is hard to understand for you?



