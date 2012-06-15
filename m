Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2FOS2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:28:25 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62640 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab2FOS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:28:24 -0400
Date: Fri, 15 Jun 2012 20:28:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Cromie <jim.cromie@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20120615182818.GA22037@gmail.com>
References: <1339601367-17834-1-git-send-email-acme@infradead.org>
 <20120614100710.GB19531@gmail.com>
 <20120615171310.GD11550@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120615171310.GD11550@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Thu, Jun 14, 2012 at 12:07:10PM +0200, Ingo Molnar escreveu:
> > Hm, fails to build here:
> > 
> >     CC util/parse-events-bison.o
> > util/parse-events.l: In function ‘__value’:
> > util/parse-events.l:18:10: error: ‘PE_ERROR’ undeclared (first 
> > use in this function)
> > util/parse-events.l:18:10: note: each undeclared identifier is 
> > reported only once for each function it appears in
> > util/parse-events.l:20:2: error: ‘parse_events_lval’ undeclared 
> > (first use in this function)
> > util/parse-events.l: In function ‘value’:
> > util/parse-events.l:26:42: error: ‘PE_VALUE’ undeclared (first 
> > use in this function)
> > util/parse-events.l: In function ‘raw’:
> > util/parse-events.l:31:44: error: ‘PE_RAW’ undeclared (first use 
> > in this function)
> > util/parse-events.l: In function ‘str’:
> > 
> > stock Fedora 17 install. 25f42985825d builds fine.
> 
> Is this 32-bit? I'm installing another VM now, but on Fedora 17 x86_64:

No, 64-bit - I'll send you more info off-list.

Thanks,

	Ingo
