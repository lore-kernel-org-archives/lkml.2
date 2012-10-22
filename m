Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2JVJMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:12:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab2JVJMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:12:40 -0400
Date: Mon, 22 Oct 2012 11:12:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 09/11] perf test: Add parse events tests for leader
 sampling
Message-ID: <20121022091220.GB6759@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
 <1350743599-4805-10-git-send-email-jolsa@redhat.com>
 <87wqyij32p.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqyij32p.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 05:58:22PM +0900, Namhyung Kim wrote:
> On Sat, 20 Oct 2012 16:33:17 +0200, Jiri Olsa wrote:
> > Adding 2 more tests to the automated parse events suite
> > for following event config:
> >
> >   '{cycles,cache-misses,branch-misses}:S'
> >   '{instructions,branch-misses}:Su'
> [snip]
> > +static int test__leader_sample2(struct perf_evlist *evlist __maybe_unused)
> > +{
> > +	struct perf_evsel *evsel, *leader;
> > +
> > +	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
> > +
> > +	/* cycles - sampling group leader */
> 
> s/cycles/instructions/ ?

right

thanks,
jirka
