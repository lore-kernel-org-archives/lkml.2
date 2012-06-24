Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2FXP7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:59:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34098 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2FXP7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:59:35 -0400
MIME-Version: 1.0
In-Reply-To: <87mx3zhekz.fsf@sejong.aot.lge.com>
References: <1339944948-3193-1-git-send-email-namhyung@kernel.org>
	<20120618090501.GB28824@gmail.com>
	<87mx3zhekz.fsf@sejong.aot.lge.com>
Date: Mon, 25 Jun 2012 00:59:34 +0900
Message-ID: <CAMO-S2jPvVZndo3_cM67ZvXXV5y5CKvxe-x6YGfguq3w9mVbAg@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Fix an error on perf-bench document
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 5:48 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi, Ingo
>
> On Mon, 18 Jun 2012 11:05:01 +0200, Ingo Molnar wrote:
>> There's several typos all across the perf bench documentation:
>>
>> 1)
>>
>>        This perf bench command is general framework for benchmark suites.
>>
>> s/is general/is a general
>>
>
> Will fix.
>
>
>> 2)
>>
>> The output of 'perf bench --help' outputs weird looking
>> formatting characters like:
>>
>>            .ft C
>>            % perf bench sched pipe                      # with no style specified
>>            (executing 1000000 pipe operations between two tasks)
>>                    Total time:5.855 sec
>>                            5.855061 usecs/op
>>                            170792 ops/sec
>>            .ft
>>
>
> I have no idea on this, maybe a problem of asciidoc?
>
>
>> 3)
>>
>> This:
>>
>>            all: test all suite (pseudo suite)
>>
>> s/all suite (psudo suite)/all benchmark suites
>>
>> (this should be fixed for perf bench mem as well.)
>>
>
> Will fix.
>
>
>> 4)
>>
>> perf bench mem memcpy -h outputs:
>>
>>     -l, --length <1MB>    Specify length of memory to copy. available unit: B, MB, GB (upper and lower)
>>
>> bad capitalization: s/. a/. A
>>
>> s/unit/units
>>
>
> Will fix too.
>
>
>> 5)
>>
>> This:
>>
>>     -c, --clock           Use CPU clock for measuring
>>
>> should probably clarify why the CPU clock matters and what
>> measurement is done otherwise.
>>
>
> This looks a bit weird. If -c switch was given, it'd use the cycles
> event not the cpu-clock event. If omitted, it'd use the gtod().
>

Very sorry, I misused the terms clock and cycles. The memset uses
hardware cycles event, the above naming and description with "clock"
is very bad...
I will write and send a patch for fix the problem.

-- 
Hitoshi Mitake
h.mitake@gmail.com
