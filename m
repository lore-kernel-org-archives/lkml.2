Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab2ILNuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:50:06 -0400
Received: from [205.233.59.134] ([205.233.59.134]:40572 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2ILNuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:50:03 -0400
Date: Wed, 12 Sep 2012 06:48:39 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 16/18] perf evsel: Introduce perf_evsel__{str,int}val
 methods
Message-ID: <20120912134839.GC10019@ghostprotocols.net>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
 <1347407590-30960-17-git-send-email-acme@infradead.org>
 <87k3w09e24.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3w09e24.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 12, 2012 at 11:21:07AM +0900, Namhyung Kim escreveu:
> On Tue, 11 Sep 2012 20:53:08 -0300, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > Wrappers to the libtraceevent routines, so that we can further reduce
> > the surface contact perf builtins have with it.
> 
> I just realized that this breaks the python extension:
> 
> namhyung@sejong:perf$ python/twatch.py 
> Traceback (most recent call last):
>   File "python/twatch.py", line 16, in <module>
>     import perf
> ImportError: /home/namhyung/project/linux/tools/perf/python/perf.so: undefined symbol: pevent_find_field

Argh2 :-\

I really need to add this to perf test :-\

- Arnaldo
