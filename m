Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1HNUBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 16:01:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45387 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1HNUBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 16:01:49 -0400
Date: Sun, 14 Aug 2011 23:01:39 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        peterz@infradead.org
Subject: Re: [Bug #39342] [3.0.0-rc6-git7] possible recursive locking at
 cache_alloc_refill
In-Reply-To: <bkwpSnItbJM.A.o3.YNCSOB@chimera>
Message-ID: <alpine.DEB.2.00.1108142259120.4228@tiger>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera> <bkwpSnItbJM.A.o3.YNCSOB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Aug 2011, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.39 and 3.0.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.39 and 3.0.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39342
> Subject		: [3.0.0-rc6-git7] possible recursive locking at cache_alloc_refill
> Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Date		: 2011-07-11 12:37 (35 days old)
> Message-ID	: <201107112137.FAD00545.SHtLOFOJOMFQFV@I-love.SAKURA.ne.jp>
> References	: http://marc.info/?l=linux-kernel&m=131038788902151&w=2

Tetsuio, did Peter's commit 30765b9 ("slab, lockdep: Annotate the locks 
before using them") and commit 83835b3 ("slab, lockdep: Annotate slab -> 
rcu -> debug_object -> slab") in Linus' git fix this for you?

 			Pekka

