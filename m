Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2HGPxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:53:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53010 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2HGPxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:53:49 -0400
Date: Tue, 7 Aug 2012 17:53:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Initial bash completion support
Message-ID: <20120807155341.GD12858@somewhere.redhat.com>
References: <1344345586-15068-1-git-send-email-fweisbec@gmail.com>
 <1344345586-15068-2-git-send-email-fweisbec@gmail.com>
 <50212222.2000509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50212222.2000509@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 08:11:46AM -0600, David Ahern wrote:
> On 8/7/12 7:19 AM, Frederic Weisbecker wrote:
> >This implements bash completion for perf subcommands such
> >as record, report, script, probe, etc...
> 
> Love it!
> 
> >
> >Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> >Cc: David Ahern <dsahern@gmail.com>
> >Cc: Ingo Molnar <mingo@kernel.org>
> >Cc: Jiri Olsa <jolsa@redhat.com>
> >Cc: Namhyung Kim <namhyung@gmail.com>
> >Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >Cc: Stephane Eranian <eranian@google.com>
> >---
> >  tools/perf/Makefile        |    1 +
> >  tools/perf/bash_completion |   20 +++++++++++++
> >  tools/perf/perf.c          |   69 +++++++++++++++++++++++++-------------------
> >  3 files changed, 60 insertions(+), 30 deletions(-)
> >  create mode 100644 tools/perf/bash_completion
> >
> >diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> >index 35655c3..4000d72 100644
> >--- a/tools/perf/Makefile
> >+++ b/tools/perf/Makefile
> >@@ -951,6 +951,7 @@ install: all
> >  	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
> >  	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
> >  	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
> >+	$(INSTALL) -m 755 bash_completion /etc/bash_completion.d/perf
> 
> $(DESTDIR_SQ) is need in front of the destination.

Right. Fixing this.

Thanks.

> 
> David
