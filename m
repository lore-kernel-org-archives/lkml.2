Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2HVORV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:17:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56018 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2HVORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:17:19 -0400
Date: Wed, 22 Aug 2012 16:17:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulrich Drepper <drepper@gmail.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Fix 'No libunwind found' make warning message
Message-ID: <20120822141711.GA30317@gmail.com>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
 <20120821093231.GA12385@gmail.com>
 <20120821093628.GA981@krava.brq.redhat.com>
 <20120822083812.GC1003@krava.brq.redhat.com>
 <20120822084017.GA21581@gmail.com>
 <1345642439.5069.27.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345642439.5069.27.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2012-08-22 at 10:40 +0200, Ingo Molnar wrote:
> >  
> > >  FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
> > >  ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
> > > -	msg := $(warning No libunwind found. Please install libunwind >= 0.99);
> > > +	msg := $(warning No libunwind found, disables post unwind support. Please install libunwind-dev[el] >= 0.99);
> > 
> > s/disables/disable
> 
> Is it a command for the user to do, or something it is about to do for
> the user? If the latter, then "disabling" may be the better word.

Yeah, agreed 'disabling' is even better.

Thanks,

	Ingo
