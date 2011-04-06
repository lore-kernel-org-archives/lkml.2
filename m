Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1DFOKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:10:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:48125 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab1DFOKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:10:11 -0400
Date: Wed, 6 Apr 2011 11:09:58 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH -tip v3 3/6] perf branch trace: print pid and command
Message-ID: <20110406140958.GA4987@ghostprotocols.net>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
 <20110324113209.20235.61900.stgit@localhost6.localdomain6>
 <4D8B79E6.2050603@gmail.com>
 <4D8C6B1B.70409@hitachi.com>
 <4D8CAE74.9080805@gmail.com>
 <4D906450.1040809@hitachi.com>
 <4D909BBB.5020500@gmail.com>
 <20110401151313.GC2335@nowhere>
 <4D96072E.4060902@gmail.com>
 <20110406121501.GA1867@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406121501.GA1867@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 06, 2011 at 02:15:07PM +0200, Frederic Weisbecker escreveu:
> On Fri, Apr 01, 2011 at 11:11:10AM -0600, David Ahern wrote:
> > On 04/01/11 09:13, Frederic Weisbecker wrote:
> > > But well, we can start simple and make and just do the => trick
> > > if we have PERF_SAMPLE_ADDR and resolve addr if the user asked
> > > the sym. Then when we have the graph output, have these per evsel
> > > display callbacks.

> > There is another email thread about page faults. The user wants sample
> > address resolved to symbols. I was going to look into it next week when
> > I get back from vacation.
 
> What we seem to need for that is to bring a pagefault tracepoint. We had
> propositions for that in the past, but work on this is in pause mode it
> seems.

Isn't there one in the 'tip/tmp.perf/trace' tmp branch? Lemme see...

Yeah, and it is even yours ;-)

commit 6a824e89c0dfe6bce3d7e85f987ec9c8e7304b34
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Fri Nov 12 05:35:06 2010 +0100

    perf, mm: Add fault tracing
    
    Part of that are two modified patches from Jiri Olsa who added the
    fault tracepoints. I had to split them in two tracepoints so that we get
    the faults handling duration.
    
    Originally-from: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Can we dust this one off and get the ball rolling again? 

- Arnaldo
