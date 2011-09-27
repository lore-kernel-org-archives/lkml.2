Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1I0ODN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 10:03:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48755 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1I0ODM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 10:03:12 -0400
Subject: Re: [PATCH 2/4] trace: prepare to collect call chains of
 non-current task.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 27 Sep 2011 16:02:31 +0200
In-Reply-To: <1317052535-1765247-3-git-send-email-avagin@openvz.org>
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
	 <1317052535-1765247-3-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317132151.15383.64.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 19:55 +0400, Andrew Vagin wrote:
> +perf_callchain_kernel(struct perf_callchain_entry *entry,
> +                       struct task_struct *tsk, struct pt_regs *regs) 

Hmm, we have event->ctx->task, but I guess for per-cpu events that's
useless..


