Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2IIIkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 04:40:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45772 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2IIIkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 04:40:51 -0400
Date: Sun, 9 Sep 2012 10:40:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Irina Tirdea <irina.tirdea@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20120909084045.GA972@gmail.com>
References: <1347136614-25598-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347136614-25598-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> Thanks,
> 
> - Arnaldo
> 
> The following changes since commit ef34eb4da3eb62a1511592adf7c76d74faca0b14:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-09-08 13:26:02 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 6c7f631261064762a8ba1ee34fc2b76d117ef3fa:
> 
>   perf symbols: Remove BIONIC wrapper around libgen.h (2012-09-08 17:15:16 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> . Don't pass const char pointers to basename, so that we can unconditionally
>   use libgen.h and thus avoid ifdef BIONIC lines, from David Ahern
> 
> . Fix assert/BUG_ON when NDEBUG is defined, from Irina Tirdea.
> 
> . Refactor hist formatting so that it can be reused with the GTK browser,
>   From Namhyung Kim
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> David Ahern (3):
>       perf annotate: Make a copy of filename for passing to basename
>       perf probe: Make a copy of exec path for passing to basename
>       perf symbols: Remove BIONIC wrapper around libgen.h
> 
> Irina Tirdea (1):
>       perf bench: fix assert when NDEBUG is defined
> 
> Namhyung Kim (5):
>       perf hists: Introduce perf_hpp for hist period printing
>       perf hists: Handle field separator properly
>       perf hists: Use perf_hpp__format->width to calculate the column widths
>       perf hists browser: Use perf_hpp__format functions
>       perf gtk/browser: Use perf_hpp__format functions
> 
>  tools/perf/Makefile                    |    2 +
>  tools/perf/bench/sched-pipe.c          |    6 +-
>  tools/perf/builtin-diff.c              |    1 +
>  tools/perf/ui/browsers/hists.c         |   96 ++++++--
>  tools/perf/ui/gtk/browser.c            |  101 +++++++--
>  tools/perf/ui/gtk/gtk.h                |    1 +
>  tools/perf/ui/gtk/setup.c              |    1 +
>  tools/perf/ui/hist.c                   |  389 ++++++++++++++++++++++++++++++++
>  tools/perf/ui/setup.c                  |    8 +-
>  tools/perf/ui/stdio/hist.c             |  239 ++++----------------
>  tools/perf/ui/tui/setup.c              |    4 +
>  tools/perf/util/annotate.c             |    9 +-
>  tools/perf/util/hist.c                 |   33 ---
>  tools/perf/util/hist.h                 |   37 +++
>  tools/perf/util/include/linux/kernel.h |    4 +
>  tools/perf/util/probe-event.c          |   12 +-
>  tools/perf/util/symbol.h               |    2 -
>  17 files changed, 665 insertions(+), 280 deletions(-)
>  create mode 100644 tools/perf/ui/hist.c

Pulled, thanks Arnaldo!

	Ingo
