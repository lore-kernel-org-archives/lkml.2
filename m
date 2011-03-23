Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1CWIpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:45:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60857 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab1CWIpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:45:03 -0400
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
In-Reply-To: <20110323082423.GA1969@barrios-desktop>
References: <20110323161354.1AD2.A69D9226@jp.fujitsu.com> <20110323082423.GA1969@barrios-desktop>
Message-Id: <20110323174545.1AE2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 23 Mar 2011 17:44:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Boo.
> > You seems forgot why you introduced current all_unreclaimable() function.
> > While hibernation, we can't trust all_unreclaimable.
> 
> Hmm. AFAIR, the why we add all_unreclaimable is when the hibernation is going on,
> kswapd is freezed so it can't mark the zone->all_unreclaimable.
> So I think hibernation can't be a problem.
> Am I miss something?

Ahh, I missed. thans correct me. Okay, I recognized both mine and your works.
Can you please explain why do you like your one than mine?

btw, Your one is very similar andrey's initial patch. If your one is
better, I'd like to ack with andrey instead.


