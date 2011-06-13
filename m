Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab1FMLor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:44:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1FMLoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:44:46 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=Uk49GNF6wVYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=jaUjvsm7L809T60UJgkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 15/15] tracing/kprobes: Fix kprobe-tracer to support
 stack trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
In-Reply-To: <20110613102118.GF30962@elte.hu>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172914.290174627@goodmis.org>  <20110613102118.GF30962@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 07:44:44 -0400
Message-ID: <1307965484.9218.59.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 12:21 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: yrl.pp-manager.tt@hitachi.com
> > Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Namhyung Kim <namhyung@gmail.com>
> > Cc: linux-kernel@vger.kernel.org
> > Link: http://lkml.kernel.org/r/20110608070934.17777.17116.stgit@fedora15
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Very sloppy tags section as well, see previous mail.

Same cause as in previous email.

> 
> > +	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count(),
> > +			     NULL);
> 
> pointless linebreak.

Again, probably to do with the 80 char limit.

-- Steve

> 
> Thanks,
> 
> 	Ingo


