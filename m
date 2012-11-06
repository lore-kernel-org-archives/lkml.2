Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2KFThw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:37:52 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43531 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2KFThv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:37:51 -0500
MIME-Version: 1.0
In-Reply-To: <20121106185058.GD25167@tassilo.jf.intel.com>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
	<1352123463-7346-9-git-send-email-eranian@google.com>
	<20121106133135.GC25167@tassilo.jf.intel.com>
	<CABPqkBSWagWME-OLE=uiT3gqGShDuGuBXL6mz8wt7tKWubS-hg@mail.gmail.com>
	<20121106185058.GD25167@tassilo.jf.intel.com>
Date: Tue, 6 Nov 2012 20:37:50 +0100
Message-ID: <CABPqkBQmZz13wAK9nUrY_O_zau6-F_SwDox1uUNK05RKjmWPnw@mail.gmail.com>
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

On Tue, Nov 6, 2012 at 7:50 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Tue, Nov 06, 2012 at 03:29:01PM +0100, Stephane Eranian wrote:
>> On Tue, Nov 6, 2012 at 2:31 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> >> +EVENT_ATTR(cpu-cycles,                       CPU_CYCLES              );
>> >> +EVENT_ATTR(instructions,             INSTRUCTIONS            );
>> >> +EVENT_ATTR(cache-references,         CACHE_REFERENCES        );
>> >> +EVENT_ATTR(cache-misses,             CACHE_MISSES            );
>> >> +EVENT_ATTR(branch-instructions,              BRANCH_INSTRUCTIONS     );
>> >> +EVENT_ATTR(branch-misses,            BRANCH_MISSES           );
>> >> +EVENT_ATTR(bus-cycles,                       BUS_CYCLES              );
>> >> +EVENT_ATTR(stalled-cycles-frontend,  STALLED_CYCLES_FRONTEND );
>> >> +EVENT_ATTR(stalled-cycles-backend,   STALLED_CYCLES_BACKEND  );
>> >> +EVENT_ATTR(ref-cycles,                       REF_CPU_CYCLES          );
>> >
>> > The merge_events() approach from the Haswell patches should be far cleaner
>> >
>> And which patch in your HSW series implements this?
>
> [PATCH 27/32] perf, x86: Support CPU specific sysfs events
>
Will try using that one.
Thanks.
