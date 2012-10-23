Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab2JWPGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:06:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:44003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab2JWPGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:06:00 -0400
Message-ID: <1351004734.13456.35.camel@twins>
Subject: Re: [PATCHv4 0/8] perf, tool: Allow to use hw events in PMU syntax
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 23 Oct 2012 17:05:34 +0200
In-Reply-To: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 14:53 +0200, Jiri Olsa wrote:
>  arch/x86/kernel/cpu/perf_event.c       | 121
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/perf_event.h       |   2 ++
>  arch/x86/kernel/cpu/perf_event_amd.c   |   9 +++++++
>  arch/x86/kernel/cpu/perf_event_intel.c |   9 +++++++
>  arch/x86/kernel/cpu/perf_event_p6.c    |   2 ++
>  include/linux/perf_event.h             |   3 +++

These bits look like they want to live in
arch/x86/kernel/cpu/perf_event.h, they're rather x86 specific. I moved
them over.

>  tools/perf/util/parse-events-test.c    |  68
> ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c         |  18 ++++++++++++++
>  tools/perf/util/parse-events.h         |   2 ++
>  tools/perf/util/parse-events.y         |  18 ++++++++++++++
>  tools/perf/util/pmu.c                  |   7 +++---
>  11 files changed, 256 insertions(+), 3 deletions(-) 

Acme, you ok with these bits?


