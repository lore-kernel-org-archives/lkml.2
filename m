Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2JAIRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:17:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2JAIRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:17:02 -0400
Date: Mon, 1 Oct 2012 10:16:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCHv2 00/14] perf diff: Factor diff command
Message-ID: <20121001081631.GB991@krava.brq.redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
 <20120927213102.GO16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927213102.GO16230@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 11:31:02PM +0200, Andi Kleen wrote:
> On Thu, Sep 27, 2012 at 01:09:21PM +0200, Jiri Olsa wrote:
> > hi,
> > this is v2 of diff command changes proposed in here:
> > https://lkml.org/lkml/2012/9/6/344
> > 
> > It's now rebased on new hists hpp* interface plus few
> > more additional changes.
> 
> FWIW I've been playing around with it a bit. It seems useful
> both for scaling problems and likely for performance regression tracking too.

cool ;)

> 
> Some minor issues I ran into (but no show stoppers):
> - The error messages for bad -c expressions could be better
> - I found the requirement for no space after -c unintuitive.

I'll see to that

> - It would be nice to have support for doing the bucketizing per line
> instead of per function. With a large function and/or inlining 
> it's sometimes hard to identify the actual problem
> Acme recently added this for perf report.

hm, I missed this one.. hopefully it should be no problem to add it

thanks for testing this!
jirka
