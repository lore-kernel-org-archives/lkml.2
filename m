Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1HNWhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 18:37:14 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50970 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1HNWhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 18:37:12 -0400
X-Nat-Received: from [202.181.97.72]:51478 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1313361399.32267
To: penberg@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, florian@mickler.org, peterz@infradead.org
Subject: Re: [Bug #39342] [3.0.0-rc6-git7] possible recursive locking atcache_alloc_refill
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.o3.YNCSOB@chimera>
	<alpine.DEB.2.00.1108142259120.4228@tiger>
In-Reply-To: <alpine.DEB.2.00.1108142259120.4228@tiger>
Message-Id: <201108150736.FFC69227.MQSJVFHFFOOOtL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 15 Aug 2011 07:36:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 14082011 #5898748, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Tetsuio, did Peter's commit 30765b9 ("slab, lockdep: Annotate the locks 
> before using them") and commit 83835b3 ("slab, lockdep: Annotate slab -> 
> rcu -> debug_object -> slab") in Linus' git fix this for you?

Yes. Applying these two commits fixes this problem.

Thank you.
