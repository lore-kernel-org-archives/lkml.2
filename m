Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1GOR1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:27:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1GOR1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:27:45 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=j18ZI8npW5gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=2Y8_S9Y3w5jIkkz3IXsA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH -tip 02/13] [CLEANUP]tracing/kprobes: merge trace probe
 enable/disable functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20110627072644.6528.26910.stgit@fedora15>
References: <20110627072626.6528.41792.stgit@fedora15>
	 <20110627072644.6528.26910.stgit@fedora15>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Jul 2011 13:27:42 -0400
Message-ID: <1310750862.27864.71.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 16:26 +0900, Masami Hiramatsu wrote:
> Merge redundant enable/disable functions into enable_trace_probe()
> and disable_trace_probe().
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---

This patch failed to compile with:

/home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/trace_kprobe.c: In function 'kprobe_trace_self_tests_init':
/home/rostedt/work/autotest/nobackup/linux-test.git/kernel/trace/trace_kprobe.c:1888:4: error: implicit declaration of function 'probe_event_enable'


-- Steve


