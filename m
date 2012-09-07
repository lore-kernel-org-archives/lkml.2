Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271Ab2IGJ3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab2IGJ3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:29:38 -0400
Date: Fri, 7 Sep 2012 11:26:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 07/12] perf diff: Add ratio computation way to compare
 hist entries
Message-ID: <20120907092632.GA3411@krava.brq.redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-8-git-send-email-jolsa@redhat.com>
 <871uiecrnr.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871uiecrnr.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 02:45:28PM +0900, Namhyung Kim wrote:
> On Thu,  6 Sep 2012 17:47:01 +0200, Jiri Olsa wrote:
> > Adding -c option to select computation method with the current
> > 'Delta' computation as default. Current posible values are of
> > this option are: 'delta' and 'ratio'.
> >

SNIP

> > @@ -263,6 +296,8 @@ static const struct option options[] = {
> >  		    "Show position displacement relative to baseline"),
> >  	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
> >  		    "Show only items with match in baseline"),
> > +	OPT_STRING('c', "compute", &compute_str, "delta,ratio (default delta)",
> > +		   "Entries differential computation selection"),
> 
> Why not make it OPT_CALLBACK?
> 
right, thanks

jirka
