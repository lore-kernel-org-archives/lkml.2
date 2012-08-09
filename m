Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2HIRNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:13:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59297 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2HIRNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:13:31 -0400
Date: Thu, 9 Aug 2012 13:35:15 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf tools: Initial bash completion support
Message-ID: <20120809163515.GA4084@infradead.org>
References: <1344522713-27951-1-git-send-email-fweisbec@gmail.com>
 <1344522713-27951-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344522713-27951-2-git-send-email-fweisbec@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 09, 2012 at 04:31:51PM +0200, Frederic Weisbecker escreveu:
> This implements bash completion for perf subcommands such
> as record, report, script, probe, etc...

Humm, I get this when doing my usual workflow:

[acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
make: Entering directory `/home/git/linux/tools/perf'
PERF_VERSION = 3.6.rc1.152.g5758f7
<SNIP>
install -d -m 755 '/home/acme/libexec/perf-core/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
install -d -m 755 '/home/acme/libexec/perf-core/scripts/python/bin'
install scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '/home/acme/libexec/perf-core/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
install scripts/python/*.py -t '/home/acme/libexec/perf-core/scripts/python'
install scripts/python/bin/* -t '/home/acme/libexec/perf-core/scripts/python/bin'
install -m 755 bash_completion /etc/bash_completion.d/perf
install: cannot create regular file `/etc/bash_completion.d/perf': Permission denied
make: *** [install] Error 1
make: Leaving directory `/home/git/linux/tools/perf'
[acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install

	Shouldn't it install on ~/etc/bash_completion.d/perf ?

	Is there a way to have per user bash completion files like that?

- Arnaldo
