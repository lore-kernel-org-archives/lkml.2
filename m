Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2IGFjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:39:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45833 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2IGFjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:39:46 -0400
Date: Fri, 7 Sep 2012 07:39:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>,
        Joel Uckelman <joel@lightboxtechnologies.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/8] perf/core improvements and fixes
Message-ID: <20120907053939.GB6194@gmail.com>
References: <1346959881-22427-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346959881-22427-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 7a4ec938857cf534270b23545495300fbac7f5de:
> 
>   perf tools: Allow user to indicate path to objdump in command line (2012-09-05 19:41:55 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 275ef3878f698941353780440fec6926107a320b:
> 
>   perf tools: Fix cache event name generation (2012-09-06 15:01:08 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> . Fix hardware cache event name generation, fix from Jiri Olsa
> 
> . Add round trip test for sw, hw and cache event names, catching the
>   problem Jiri fixed, after Jiri's patch, the test passes successfully.
> 
> . Clean target should do clean for lib/traceevent too, fix from David Ahern
> 
> . Check the right variable for allocation failure, fix from Namhyung Kim
> 
> . Set up evsel->tp_format regardless of evsel->name being set already,
>   fix from Namhyung Kim
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (4):
>       perf test: Add round trip test for sw and hw event names
>       perf tools: Remove extraneous newline when parsing hardware cache events
>       perf evlist: Add fprintf method
>       perf test: Add roundtrip test for hardware cache events
> 
> David Ahern (1):
>       perf tools: Clean target should do clean for lib/traceevent too
> 
> Jiri Olsa (1):
>       perf tools: Fix cache event name generation
> 
> Namhyung Kim (2):
>       perf header: Fix a typo on evsel
>       perf header: Prepare tracepoint events regardless of name
> 
>  tools/perf/Makefile            |    5 +-
>  tools/perf/builtin-test.c      |  114 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/evlist.c       |   13 +++++
>  tools/perf/util/evlist.h       |    2 +
>  tools/perf/util/evsel.c        |    6 +--
>  tools/perf/util/evsel.h        |    6 ++-
>  tools/perf/util/header.c       |   36 ++++++++-----
>  tools/perf/util/parse-events.c |    2 +-
>  8 files changed, 163 insertions(+), 21 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
