Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0KWHRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:17:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37381 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab0KWHRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:17:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1011141333330.22262@chino.kir.corp.google.com>
References: <20101114135323.E00D.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141333330.22262@chino.kir.corp.google.com>
Message-Id: <20101123160259.7B9C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:16:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:
> 
> > No irrelevant. Your patch break their environment even though
> > they don't use oom_adj explicitly. because their application are using it.
> > 
> 
> The _only_ difference too oom_adj since the rewrite is that it is now 
> mapped on a linear scale rather than an exponential scale.  

_only_ mean don't ZERO different. Why do userland application need to rewrite?


> That's because 
> the heuristic itself has a defined range [0, 1000] that characterizes the 
> memory usage of the application it is ranking.  To show any breakge, you 
> would have to show how oom_adj values being used by applications are based 
> on a calculated value that prioritizes those tasks amongst each other.  
> With the exponential scale, that's nearly impossible because of the number 
> of arbitrary heuristics that were used before oom_adj were considered 
> (runtime, nice level, CAP_SYS_RAWIO, etc).

But, No people have agreed your powerfulness even though you talked about
the same explanation a lot of times.

Again, IF you need to [0 .. 1000] range, you can calculate it by your
application. current oom score can be get from /proc/pid/oom_score and
total memory can be get from /proc/meminfo. You shouldn't have break
anything.


> So don't talk about userspace breakage when you can't even describe it or 
> present a single usecase.

Huh? Remember! your feature have ZERO user.



