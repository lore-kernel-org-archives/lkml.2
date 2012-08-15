Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab2HONGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:06:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:36849 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab2HONGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:06:53 -0400
Date: Wed, 15 Aug 2012 10:06:34 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
Message-ID: <20120815130634.GE2370@infradead.org>
References: <1344864055.6935.117.camel@gandalf.stny.rr.com>
 <20120813132438.GA18990@aftab.osrc.amd.com>
 <1344867782.6935.119.camel@gandalf.stny.rr.com>
 <20120813142909.GC18990@aftab.osrc.amd.com>
 <20120813180249.GB6840@infradead.org>
 <20120815102722.GB4640@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815102722.GB4640@aftab.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 15, 2012 at 12:27:22PM +0200, Borislav Petkov escreveu:
> On Mon, Aug 13, 2012 at 03:02:49PM -0300, Arnaldo Carvalho de Melo wrote:
> > [acme@sandy linux]$ rm -rf ../build/perf
> > [acme@sandy linux]$ make -j8 -C tools/perf/ LIBUNWIND_DIR=/opt/libunwind O=/home/acme/git/build/perf install
> > /bin/sh: line 0: cd: /home/acme/git/build/perf: No such file or directory
> > make: Entering directory `/home/git/linux/tools/perf'
> >     GEN perf-archive
> >     GEN /home/git/linux/tools/perf/python/perf.so
> > make[1]: Entering directory `/home/git/linux/tools/lib/traceevent'
> >     * new build flags or cross compiler
> >     CC /home/git/linux/tools/perf/perf.o

> > I.e. it should stop if the O= provided directory is not there.

> Why stop? Don't we want to make the directory instead and continue
> building in there?

That was the case in the past, but IIRC PeterZ advocated not to and I
agreed.

- Arnaldo
