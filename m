Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab2KFO3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 09:29:05 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48083 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2KFO3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 09:29:03 -0500
MIME-Version: 1.0
In-Reply-To: <20121106133135.GC25167@tassilo.jf.intel.com>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
	<1352123463-7346-9-git-send-email-eranian@google.com>
	<20121106133135.GC25167@tassilo.jf.intel.com>
Date: Tue, 6 Nov 2012 15:29:01 +0100
Message-ID: <CABPqkBSWagWME-OLE=uiT3gqGShDuGuBXL6mz8wt7tKWubS-hg@mail.gmail.com>
Subject: Re: [PATCH v2 08/16] perf/x86: add memory profiling via PEBS Load Latency
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 2:31 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> +EVENT_ATTR(cpu-cycles,                       CPU_CYCLES              );
>> +EVENT_ATTR(instructions,             INSTRUCTIONS            );
>> +EVENT_ATTR(cache-references,         CACHE_REFERENCES        );
>> +EVENT_ATTR(cache-misses,             CACHE_MISSES            );
>> +EVENT_ATTR(branch-instructions,              BRANCH_INSTRUCTIONS     );
>> +EVENT_ATTR(branch-misses,            BRANCH_MISSES           );
>> +EVENT_ATTR(bus-cycles,                       BUS_CYCLES              );
>> +EVENT_ATTR(stalled-cycles-frontend,  STALLED_CYCLES_FRONTEND );
>> +EVENT_ATTR(stalled-cycles-backend,   STALLED_CYCLES_BACKEND  );
>> +EVENT_ATTR(ref-cycles,                       REF_CPU_CYCLES          );
>
> The merge_events() approach from the Haswell patches should be far cleaner
>
And which patch in your HSW series implements this?

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
