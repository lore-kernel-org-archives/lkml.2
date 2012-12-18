Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2LRHle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:41:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab2LRHld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:41:33 -0500
Date: Tue, 18 Dec 2012 08:41:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/3] perf tool: Add support to include non architectural
 event aliases
Message-ID: <20121218074114.GB1283@krava.brq.redhat.com>
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
 <1355751425-7993-3-git-send-email-jolsa@redhat.com>
 <871ueokvto.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ueokvto.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 10:12:03AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Mon, 17 Dec 2012 14:37:04 +0100, Jiri Olsa wrote:
> > Adding support to parse non architectural event aliases
> > for given cpu. These aliases will be provided as 'events'
> > directory like architectural ones provided by kernel.
> >
> [snip]
> > +
> > +$(OUTPUT)$(OUTPUT)arch/$(ARCH)/util/pmu.o: $(OUTPUT)arch/$(ARCH)/util/pmu.c $(OUTPUT)PERF-CFLAGS
> 
> Double OUTPUT ? ;)

humm, yes ;-)

> 
> 
> > +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
> > +	 '-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
> > +	 '-DPREFIX="$(prefix_SQ)"' \
> > +	 $<
> [snip]
> > +static int cpu_aliases(struct list_head *head)
> > +{
> > +	unsigned vendol, model;
> 
> s/vendol/vendor/ ?

http://en.wikipedia.org/wiki/The_13th_Warrior
... 'Wendol', fiends who come with the mist to kill and eat human flesh ...

;-)

thanks
jirka
