Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1BGPHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:07:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab1BGPHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:07:31 -0500
Date: Mon, 7 Feb 2011 16:06:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Borislav Petkov <borislav.petkov@amd.com>,
        Denis Kirjanov <dkirjanov@kernel.org>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Kyle McMartin <kyle@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michael Witten <mfwitten@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 0/9] perf/core improvements and fixes
Message-ID: <20110207150640.GA20053@elte.hu>
References: <1297090812-10782-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297090812-10782-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Borislav Petkov (1):
>   perf annotate: Fix build error
> 
> Denis Kirjanov (1):
>   perf top: Use pid_t for target_{pid|tid}
> 
> Franck Bui-Huu (1):
>   perf probe: Rewrite find_lazy_match_lines() by using getline(3)
> 
> Kyle McMartin (1):
>   perf tool: Fix gcc 4.6.0 issues
> 
> Masami Hiramatsu (4):
>   tracing/kprobes: Cleanup strict_strtol() using code
>   tracing/kprobes: Support longer (>128 bytes) command
>   tracing/kprobes: Add bitfield type
>   perf probe: Add bitfield member support
> 
> Michael Witten (1):
>   perf tools: Makefile: Use $(QUIET_GEN) for perf.so

hm, the perf probe bits do not build on 32-bit:

util/probe-finder.c: In function ‘convert_variable_type’:
util/probe-finder.c:881: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 6 has type ‘unsigned int’
util/probe-finder.c:881: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 6 has type ‘unsigned int’
make: *** [util/probe-finder.o] Error 1
make: *** Waiting for unfinished jobs....

Thanks,

	Ingo
