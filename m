Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab2JCRBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:01:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965071Ab2JCRBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:01:41 -0400
Date: Wed, 3 Oct 2012 19:01:14 +0200
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
Message-ID: <20121003170114.GF945@krava.brq.redhat.com>
References: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
 <20120927213102.GO16230@one.firstfloor.org>
 <20121001081631.GB991@krava.brq.redhat.com>
 <20121002163002.GD16230@one.firstfloor.org>
 <20121003165532.GI16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003165532.GI16230@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 06:55:32PM +0200, Andi Kleen wrote:
> > > hm, I missed this one.. hopefully it should be no problem to add it
> > 
> > Here's more issues I found (again no show stopper):
> 
> And another issue (this one is more serious):
> 
> I was trying to compare the same program with two different kernels.
> But perf diff does not recognize the same functions in the kernels
> as the same bucket. So I cannot actually "ratio" the different 
> kernel versions.

good point, I'll check how we can fix this

thanks,
jirka
