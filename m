Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2GTIOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 04:14:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52030 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab2GTIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 04:14:18 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-8e-50091357e570
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: Re: [PATCHv4 0/4] perf tool: Add new event group management
References: <1342734837-1825-1-git-send-email-jolsa@redhat.com>
Date: Fri, 20 Jul 2012 17:09:33 +0900
In-Reply-To: <1342734837-1825-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 19 Jul 2012 23:53:53 +0200")
Message-ID: <87629i3lc2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri

On Thu, 19 Jul 2012 23:53:53 +0200, Jiri Olsa wrote:
> hi,
> adding support for creating event groups based on the way they
> are specified on the command line.
>
> This patchset adds the '{}' style grammar to express event group,
> allowing so far only the 'event modifier' as group modifier.
>
> v4 changes:
>   - group modifier updates events modifiers (not overwrite as in v3)
>
> Attached patches:
>   perf, tool: Add support to parse event group syntax
>   perf, tool: Add support to update event modifier
>   perf, tool: Enable grouping logic for parsed events
>   perf, test: Add automated tests for event group parsing
>

Thanks for keeping working on this. You can add my

  Reviewed-by: Namhyung Kim <namhyung@kernel.org>

for all of the patches if you want.

Btw, is it all of your user-space changes?

Thanks,
Namhyung


> wbr,
> jirka
> ---
>  tools/perf/builtin-record.c         |   13 ++-
>  tools/perf/builtin-stat.c           |   13 ++-
>  tools/perf/builtin-test.c           |    8 +-
>  tools/perf/builtin-top.c            |   12 +--
>  tools/perf/util/evlist.c            |   20 ++---
>  tools/perf/util/evlist.h            |    3 +-
>  tools/perf/util/evsel.c             |   51 +++++++----
>  tools/perf/util/evsel.h             |   13 +--
>  tools/perf/util/parse-events-test.c |  303 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  tools/perf/util/parse-events.c      |  104 +++++++++++++++++++---
>  tools/perf/util/parse-events.h      |    5 +-
>  tools/perf/util/parse-events.l      |    2 +
>  tools/perf/util/parse-events.y      |   93 +++++++++++++++++---
>  tools/perf/util/python.c            |    7 +-
>  14 files changed, 552 insertions(+), 95 deletions(-)
