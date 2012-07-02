Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2GBB6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 21:58:01 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48230 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2GBB57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 21:57:59 -0400
X-AuditID: 9c930179-b7cceae000004195-6d-4ff1002503f5
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
Date: Mon, 02 Jul 2012 10:53:44 +0900
In-Reply-To: <1340960907-3725-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Fri, 29 Jun 2012 11:08:24 +0200")
Message-ID: <87fw9blyhj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri

On Fri, 29 Jun 2012 11:08:24 +0200, Jiri Olsa wrote:
> hi,
> adding support for creating event groups based on the way they
> are specified on the command line.
>
> This patchset adds the '{}' style grammar to express event group,
> allowing so far only the 'event modifier' as group modifier.
>
> The sample/leader modifier changes are ready, but I'm getting
> some weird numbers in tests, so I'll send it later. Meanwhile,
> it'd be nice to have at least this patchset in.. ;)
>

Just a question, is there a way to know about the grouping at perf
report time?

Thanks,
Namhyung


>
> Attached patches:
>   1/3 perf, tool: Add support to parse event group syntax
>   2/3 perf, tool: Enable grouping logic for parsed events
>   3/3 perf, test: Add automated tests for event group parsing
>
> wbr,
> jirka
> ---
>  tools/perf/builtin-record.c         |   13 +--
>  tools/perf/builtin-stat.c           |   13 +--
>  tools/perf/builtin-test.c           |    8 +-
>  tools/perf/builtin-top.c            |   12 +--
>  tools/perf/util/evlist.c            |   20 ++---
>  tools/perf/util/evlist.h            |    3 +-
>  tools/perf/util/evsel.c             |   51 ++++++++----
>  tools/perf/util/evsel.h             |   11 +--
>  tools/perf/util/parse-events-test.c |  152 +++++++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c      |   32 +++++++-
>  tools/perf/util/parse-events.h      |    5 +-
>  tools/perf/util/parse-events.l      |    2 +
>  tools/perf/util/parse-events.y      |   93 ++++++++++++++++++---
>  tools/perf/util/python.c            |    7 +-
>  14 files changed, 341 insertions(+), 81 deletions(-)
