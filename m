Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1ARBQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:16:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab1ARBQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:16:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
In-Reply-To: Frederic Weisbecker's message of  Tuesday, 18 January 2011 00:58:30 +0100 <20110117235828.GE16856@nowhere>
References: <20101108145647.GA3426@redhat.com>
	<20101108184057.GB5375@nowhere>
	<20101108191813.GA15223@redhat.com>
	<20110117235828.GE16856@nowhere>
X-Zippy-Says: UH-OH!!  We're out of AUTOMOBILE PARTS and RUBBER GOODS!
Message-Id: <20110118011600.CBD9F180996@magilla.sf.frob.com>
Date: Mon, 17 Jan 2011 17:16:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Aah, so we check if the task is stopped when sys_ptrace() is called,
> but right after we do this check, the tracee can be resumed at any time?
> (with either SIGCONT or SIGKILL), even if we are servicing the ptrace
> request at the same time?

Only by SIGKILL.
