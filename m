Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1FMKUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:20:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54207 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1FMKUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:20:09 -0400
Date: Mon, 13 Jun 2011 12:19:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 14/15] stack_trace: Add weak save_stack_trace_regs()
Message-ID: <20110613101955.GE30962@elte.hu>
References: <20110609172744.333794089@goodmis.org>
 <20110609172914.028158916@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609172914.028158916@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> +save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
> +{
> +	WARN_ONCE(1,
> +		  KERN_INFO "save_stack_trace_regs() not implemented yet.\n");

 - pointless linebreak
 - we don't add KERN_ tags to WARN*() invocations

Thanks,

	Ingo
