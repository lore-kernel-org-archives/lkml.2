Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2JUNeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 09:34:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36675 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2JUNeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 09:34:02 -0400
Date: Sun, 21 Oct 2012 15:33:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/11] perf python: Link with libtraceevent
Message-ID: <20121021133356.GB23425@gmail.com>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
 <1350494387-10987-10-git-send-email-acme@infradead.org>
 <87y5j41rw5.fsf@sejong.aot.lge.com>
 <20121018140033.GC2057@infradead.org>
 <20121018143835.GE2057@infradead.org>
 <1350574827.1610.8.camel@leonhard>
 <20121020003556.GA15567@gmail.com>
 <20121020150429.GA27221@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121020150429.GA27221@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Sat, Oct 20, 2012 at 02:35:57AM +0200, Ingo Molnar escreveu:
> > Even with that I'm getting:
> > 
> > util/python.c: In function ???initperf???:
> > util/python.c:1018:2: error: ???page_size??? undeclared 
> > (first use in this function)
> > util/python.c:1018:2: note: each undeclared identifier is 
> > reported only once for each function it appears in
> > error: command 'gcc' failed with exit status 1
> 
> Yeah, there was another problem, a patch that makes sense only 
> for perf/core was added, I reverted it after Namhyung reported 
> the same problem:

Yeah.

So, you being on conference and me trying to not miss -rc2 with 
a couple of high-profile perf fixes I ended up resolving this 
bug in the merge commit, the almost-evil merge a448a03 and such.

That's now upstream - mind checking whether anything is still 
amiss?

Thanks,

	Ingo
