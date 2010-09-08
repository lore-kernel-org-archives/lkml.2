Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0IHCoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:44:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36913 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab0IHCoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:44:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUGFIX for 2.6.36][RESEND][PATCH 1/2] oom: remove totalpage normalization from oom_badness()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <20100831181911.87E7.A69D9226@jp.fujitsu.com>
References: <20100831181911.87E7.A69D9226@jp.fujitsu.com>
Message-Id: <20100907120046.C90A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  8 Sep 2010 11:44:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ok, this one got no objection except original patch author.
> then, I'll push it to mainline. I'm glad that I who stabilization
> developer have finished this work.
> 
> If you think this patch is slightly large, please run,
>  % git diff a63d83f42^ mm/oom_kill.c
> you'll understand this is minimal revert of unnecessary change.


Andrew, please don't be lazy this one. I don't hope to slip this anymore.
I was making the patch as you requested. but no responce. I who stabilization
developr can't permit this userland breakage and sucky status. please
join to fix it. Sadly, The delay will be increase, I have to switch 
full revert entirely instead your opinion.

Spell out: I don't hope to continus this crazy discussion. a userland 
breakage bug is a bug, not anything else. I don't hope to talk this 
one anymore even though it's only 5 miniture. I don't think any rare
usecase feature should die. but ZERO USER FEATURE SHOULDN'T BREAK USERLAND.




