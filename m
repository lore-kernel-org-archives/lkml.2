Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab2KCLEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:04:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43997 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2KCLEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 07:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <20121030122032.GC3888@suse.de>
References: <20121025121617.617683848@chello.nl>
	<20121030122032.GC3888@suse.de>
Date: Sat, 3 Nov 2012 19:04:04 +0800
Message-ID: <CAGjg+kHrbjr8T0+TOEKp6Mx4zZBbrh_3VPUt81nWj6u3xi=NNQ@mail.gmail.com>
Subject: Re: [PATCH 00/31] numa/core patches
From: Alex Shi <lkml.alex@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> In reality, this report is larger but I chopped it down a bit for
> brevity. autonuma beats schednuma *heavily* on this benchmark both in
> terms of average operations per numa node and overall throughput.
>
> SPECJBB PEAKS
>                                        3.7.0                      3.7.0                      3.7.0
>                               rc2-stats-v2r1         rc2-autonuma-v27r8         rc2-schednuma-v1r3
>  Expctd Warehouse                   12.00 (  0.00%)                   12.00 (  0.00%)                   12.00 (  0.00%)
>  Expctd Peak Bops               442225.00 (  0.00%)               596039.00 ( 34.78%)               555342.00 ( 25.58%)
>  Actual Warehouse                    7.00 (  0.00%)                    9.00 ( 28.57%)                    8.00 ( 14.29%)
>  Actual Peak Bops               550747.00 (  0.00%)               646124.00 ( 17.32%)               560635.00 (  1.80%)

It is impressive report!

Could you like to share the what JVM and options are you using in the
testing, and based on which kinds of platform?

-- 
Thanks
    Alex
