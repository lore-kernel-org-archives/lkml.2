Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2DYHI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:08:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57246 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2DYHI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:08:58 -0400
Date: Wed, 25 Apr 2012 09:08:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20120425070844.GB29496@gmail.com>
References: <1334940787-16174-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334940787-16174-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> Regards,
> 
> - Arnaldo
> 
> The following changes since commit 7ea6411f4ceb62e5e53170d59d10996dca20c599:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2012-04-15 08:02:36 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent
> 
> for you to fetch changes up to 33ff581eddf744ea91a50d46c2f0961b375a9595:
> 
>   perf symbols: Read plt symbols from proper symtab_type binary (2012-04-20 13:34:49 -0300)
> 
> ----------------------------------------------------------------
> Fixes for perf/urgent
> 
> . Read PLT symbols from the same DSO as the main symtab, fix from Jiri Olsa.
> 
> . Add back the 'g' and 'h' event modifiers, they were dropped during the
>   conversion to use bison. Fix from Gleb Natapov
> 
> . Drop CROSS_COMPILE from flex and bison calls, not really needed. From
>   Otavio Salvador
> 
> . A kernel map variable can be NULL, but was being used despite the earlier
>   check. Fix from David Ahern
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> David Ahern (1):
>       perf report: Fix crash showing warning related to kernel maps
> 
> Gleb Natapov (1):
>       perf tools: Add 'G' and 'H' modifiers to event parsing
> 
> Jiri Olsa (1):
>       perf symbols: Read plt symbols from proper symtab_type binary
> 
> Otavio Salvador (1):
>       perf tools: Drop CROSS_COMPILE from flex and bison calls
> 
>  tools/perf/Makefile            |    4 ++--
>  tools/perf/builtin-report.c    |   17 ++++++++++++-----
>  tools/perf/builtin-test.c      |   30 ++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.l |    2 +-
>  tools/perf/util/symbol.c       |   13 ++++++-------
>  5 files changed, 51 insertions(+), 15 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
