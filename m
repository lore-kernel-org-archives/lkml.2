Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2ECP1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:27:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64024 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab2ECP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:27:39 -0400
Date: Thu, 3 May 2012 12:27:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 08/13] perf target: Split out perf_target handling code
Message-ID: <20120503152746.GA8807@infradead.org>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
 <1335417327-11796-9-git-send-email-namhyung.kim@lge.com>
 <20120502183026.GC5745@infradead.org>
 <1336055987.1493.17.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336055987.1493.17.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 03, 2012 at 11:39:47PM +0900, Namhyung Kim escreveu:
> 2012-05-02 (수), 15:30 -0300, Arnaldo Carvalho de Melo:
> > Em Thu, Apr 26, 2012 at 02:15:22PM +0900, Namhyung Kim escreveu:
> > > For further work on perf_target, it'd be better off splitting
> > > the code into a separate file.
> > > 
> > > Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> > > ---
> > >  tools/perf/Makefile      |    2 ++
> > >  tools/perf/perf.h        |    9 +--------
> > >  tools/perf/util/evlist.c |    1 +
> > >  tools/perf/util/evsel.c  |    1 +
> > >  tools/perf/util/target.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
> > >  tools/perf/util/target.h |   17 +++++++++++++++++
> > >  tools/perf/util/usage.c  |   34 ----------------------------------
> > >  tools/perf/util/util.h   |    2 --
> > >  8 files changed, 67 insertions(+), 44 deletions(-)
> > >  create mode 100644 tools/perf/util/target.c
> > >  create mode 100644 tools/perf/util/target.h
> > 
> > Trying to fix this now...
> > 
> 
> Oops, sorry. I'll investigate it tomorrow.
> 

I fixed it, its on my latest perf/core pull req to Ingo.

- Arnaldo
