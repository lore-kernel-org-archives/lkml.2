Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab2JaHYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:24:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52929 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2JaHY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:24:29 -0400
X-AuditID: 9c930179-b7c8bae000003559-79-5090d22b45c3
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Arun Sharma <asharma@fb.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist periods
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
	<1351537727.4047.21.camel@twins> <508EF6C1.4000302@fb.com>
	<87ehkg78dx.fsf@sejong.aot.lge.com> <1351585065.4047.33.camel@twins>
	<20121030090110.GA10193@gmail.com>
Date: Wed, 31 Oct 2012 16:24:27 +0900
In-Reply-To: <20121030090110.GA10193@gmail.com> (Ingo Molnar's message of
	"Tue, 30 Oct 2012 10:01:10 +0100")
Message-ID: <87wqy73xzo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 10:01:10 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> On Tue, 2012-10-30 at 15:59 +0900, Namhyung Kim wrote:
>
>> > Yes, the callchain part needs to be improved.  Peter's idea 
>> > indeed looks good to me too.
>> 
>> FWIW, I think this is exactly what sysprof does, except that 
>> tool isn't usable for other reasons.. You might want to look 
>> at it though.
>
> I always found the fundamental sysprof system-wide call graph 
> profiling output/view superior - and so do many Xorg developers 
> who are using SysProf that I talked to - so I'd strongly 
> encourage to use that ordering and grouping for the default perf 
> call-graph profiling output/view.

Okay, I'll look at the sysprof.

Anyway, do you have any other comments for the general --cumulate
approach in this series (esp. with --branch-stack)?

Thanks,
Namhyung
