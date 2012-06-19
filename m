Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2FSIwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:52:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49489 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2FSIwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:52:09 -0400
X-AuditID: 9c930197-b7b87ae000000e4d-16-4fe03db5c660
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fix an error on perf-bench document
References: <1339944948-3193-1-git-send-email-namhyung@kernel.org>
	<20120618090501.GB28824@gmail.com>
Date: Tue, 19 Jun 2012 17:48:44 +0900
In-Reply-To: <20120618090501.GB28824@gmail.com> (Ingo Molnar's message of
	"Mon, 18 Jun 2012 11:05:01 +0200")
Message-ID: <87mx3zhekz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

On Mon, 18 Jun 2012 11:05:01 +0200, Ingo Molnar wrote:
> There's several typos all across the perf bench documentation:
>
> 1)
>
>        This perf bench command is general framework for benchmark suites.
>
> s/is general/is a general
>

Will fix.


> 2)
>
> The output of 'perf bench --help' outputs weird looking 
> formatting characters like:
>
>            .ft C
>            % perf bench sched pipe                      # with no style specified
>            (executing 1000000 pipe operations between two tasks)
>                    Total time:5.855 sec
>                            5.855061 usecs/op
>                            170792 ops/sec
>            .ft
>

I have no idea on this, maybe a problem of asciidoc?


> 3)
>
> This:
>
>            all: test all suite (pseudo suite)
>
> s/all suite (psudo suite)/all benchmark suites
>
> (this should be fixed for perf bench mem as well.)
>

Will fix.


> 4)
>
> perf bench mem memcpy -h outputs:
>
>     -l, --length <1MB>    Specify length of memory to copy. available unit: B, MB, GB (upper and lower)
>
> bad capitalization: s/. a/. A
>
> s/unit/units
>

Will fix too.


> 5)
>
> This:
>
>     -c, --clock           Use CPU clock for measuring
>
> should probably clarify why the CPU clock matters and what 
> measurement is done otherwise.
>

This looks a bit weird. If -c switch was given, it'd use the cycles
event not the cpu-clock event. If omitted, it'd use the gtod().

Thanks,
Namhyung
