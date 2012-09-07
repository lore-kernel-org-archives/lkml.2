Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab2IGJa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:30:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab2IGJaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:30:55 -0400
Date: Fri, 7 Sep 2012 11:30:04 +0200
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
Subject: Re: [PATCH 11/12] perf diff: Add -F option to display formula for
 computation
Message-ID: <20120907093004.GC3411@krava.brq.redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-12-git-send-email-jolsa@redhat.com>
 <87sjaubcaq.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjaubcaq.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 03:02:37PM +0900, Namhyung Kim wrote:
> On Thu,  6 Sep 2012 17:47:05 +0200, Jiri Olsa wrote:
> > Adding -F option to display the formula for specified computation.
> > This is mainly to facilitate debuging, but can be usefull anyway.
> >

SNIP

> > @@ -175,6 +182,7 @@ DEF_COLUMN(delta, HISTC_DELTA, 8, "Delta")
> >  DEF_COLUMN(ratio, HISTC_RATIO, 14, "Ratio")
> >  DEF_COLUMN(wdiff, HISTC_WEIGHTED_DIFF, 13, "Weighted diff")
> >  DEF_COLUMN(displacement, HISTC_DISPLACEMENT, 5, "Displ")
> > +DEF_COLUMN(formula_wdiff, HISTC_FORMULA_WEIGHTED_DIFF, 50, "Formula")
> 
> This fixed 50 column width looks too large to me.  What about make it
> dynamic like sort_list?

ok, good idea

jirka
