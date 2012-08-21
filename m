Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2HUO67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:58:59 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55167 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2HUO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:58:56 -0400
Date: Tue, 21 Aug 2012 16:58:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        =?iso-8859-1?B?Suly9G1l?= Carretero <cJ-ko@zougloub.eu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/1] perf/urgent fix
Message-ID: <20120821145849.GA4852@gmail.com>
References: <1345559961-7964-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345559961-7964-1-git-send-email-acme@infradead.org>
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
> The following changes since commit 5c65ca75209de8cc1802e7d3761b404957689cda:
> 
>   Merge branch 'tip/perf/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent (2012-08-21 11:49:37 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 3ab484b8622b7b890ca8d2ab5ee034c217ee4eeb:
> 
>   perf tools: Add missing files to build the python binding (2012-08-21 10:31:40 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fix:
> 
> . Add missing object files needed to use the python binding, cherry-picked
>   from perf/core, got a report it affects Linus's too, fix it.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (1):
>       perf tools: Add missing files to build the python binding
> 
>  tools/perf/util/python-ext-sources |    2 ++
>  1 file changed, 2 insertions(+)

Pulled, thanks!

	Ingo
