Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1E1SJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:09:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43756 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab1E1SJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:09:05 -0400
Date: Sat, 28 May 2011 20:08:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf stat: clarify unsupported events from uncounted
 events
Message-ID: <20110528180848.GC12530@elte.hu>
References: <1306515106-11967-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306515106-11967-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> After:
> 
> perf stat -ddd -- sleep 1
> 
>  Performance counter stats for 'sleep 1':
> 
>           1.350326 task-clock                #    0.001 CPUs utilized
>                  2 context-switches          #    0.001 M/sec
>                  0 CPU-migrations            #    0.000 M/sec
>                157 page-faults               #    0.116 M/sec
>             11,986 cycles                    #    0.009 GHz
>    <not supported> stalled-cycles-frontend
>    <not supported> stalled-cycles-backend
>            496,986 instructions              #   41.46  insns per cycle
>            138,065 branches                  #  102.246 M/sec
>              7,245 branch-misses             #    5.25% of all branches         [97.60%]
>      <not counted> L1-dcache-loads
>      <not counted> L1-dcache-load-misses
>      <not counted> LLC-loads
>      <not counted> LLC-load-misses
>      <not counted> L1-icache-loads
>      <not counted> L1-icache-load-misses
>      <not counted> dTLB-loads
>      <not counted> dTLB-load-misses
>      <not counted> iTLB-loads
>      <not counted> iTLB-load-misses
>      <not counted> L1-dcache-prefetches
>    <not supported> L1-dcache-prefetch-misses

That looks like a really useful distinction!

Thanks,

	Ingo
