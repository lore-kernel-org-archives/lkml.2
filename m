Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2KFSvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 13:51:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:26152 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab2KFSu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 13:50:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,722,1344236400"; 
   d="scan'208";a="238111184"
Date: Tue, 6 Nov 2012 10:50:58 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v2 08/16] perf/x86: add memory profiling via PEBS Load
 Latency
Message-ID: <20121106185058.GD25167@tassilo.jf.intel.com>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
 <1352123463-7346-9-git-send-email-eranian@google.com>
 <20121106133135.GC25167@tassilo.jf.intel.com>
 <CABPqkBSWagWME-OLE=uiT3gqGShDuGuBXL6mz8wt7tKWubS-hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSWagWME-OLE=uiT3gqGShDuGuBXL6mz8wt7tKWubS-hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 03:29:01PM +0100, Stephane Eranian wrote:
> On Tue, Nov 6, 2012 at 2:31 PM, Andi Kleen <ak@linux.intel.com> wrote:
> >> +EVENT_ATTR(cpu-cycles,                       CPU_CYCLES              );
> >> +EVENT_ATTR(instructions,             INSTRUCTIONS            );
> >> +EVENT_ATTR(cache-references,         CACHE_REFERENCES        );
> >> +EVENT_ATTR(cache-misses,             CACHE_MISSES            );
> >> +EVENT_ATTR(branch-instructions,              BRANCH_INSTRUCTIONS     );
> >> +EVENT_ATTR(branch-misses,            BRANCH_MISSES           );
> >> +EVENT_ATTR(bus-cycles,                       BUS_CYCLES              );
> >> +EVENT_ATTR(stalled-cycles-frontend,  STALLED_CYCLES_FRONTEND );
> >> +EVENT_ATTR(stalled-cycles-backend,   STALLED_CYCLES_BACKEND  );
> >> +EVENT_ATTR(ref-cycles,                       REF_CPU_CYCLES          );
> >
> > The merge_events() approach from the Haswell patches should be far cleaner
> >
> And which patch in your HSW series implements this?

[PATCH 27/32] perf, x86: Support CPU specific sysfs events 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
