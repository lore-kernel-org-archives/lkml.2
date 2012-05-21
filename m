Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2EUHT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:19:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59736 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2EUHT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:19:27 -0400
Date: Mon, 21 May 2012 09:19:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/6] perf/core fixes
Message-ID: <20120521071922.GB30748@gmail.com>
References: <1337480196-761-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337480196-761-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	This also includes a merge with tip/perf/urgent, please consider
> pulling,
> 
> - Arnaldo
> 
> The following changes since commit 978da300c7a65494692b329a6a4cbf364afc37c5:
> 
>   perf/x86/ibs: Fix undefined reference to `get_ibs_caps' (2012-05-14 14:31:35 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> for you to fetch changes up to 5e1c81d98a5621007824b49dde556fead5ff9c6c:
> 
>   perf evsel: Create events initially disabled -- again (2012-05-18 16:02:42 -0300)
> 
> ----------------------------------------------------------------
> Fixes for perf/core:
> 
> . Rename some perf_target methods to avoid double negation, from Namhyung Kim.
> 
> . Revert change to use per task events with inheritance, from Namhyung Kim.
> 
> . Events should start disabled till children starts running, from David Ahern.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       Merge remote-tracking branch 'tip/perf/urgent' into perf/core
> 
> David Ahern (1):
>       perf evsel: Create events initially disabled -- again
> 
> Jiri Olsa (2):
>       perf hists: Fix callchain ip printf format
>       perf tools: Split term type into value type and term type
> 
> Namhyung Kim (3):
>       perf target: Rename functions to avoid double negation
>       Revert 'perf evlist: Fix creation of cpu map'
>       perf target: Add uses_mmap field

Pulled, thanks a lot Arnaldo!

This should also fix the regression Linus reported, AFAICS.

Thanks,

	Ingo
