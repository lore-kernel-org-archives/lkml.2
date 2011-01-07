Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1AGT6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:58:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab1AGT6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:58:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Dario Faggioli <raistlin@linux.it>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        john.stultz@linaro.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Read THREAD_CPUTIME clock from other  processes.
In-Reply-To: Oleg Nesterov's message of  Friday, 7 January 2011 20:49:13 +0100 <20110107194913.GA29536@redhat.com>
References: <1293121303.3390.185.camel@Palantir>
	<20110107192809.05CFF40467@magilla.sf.frob.com>
	<20110107193547.GA28634@redhat.com>
	<20110107195016.2334940467@magilla.sf.frob.com>
	<20110107194913.GA29536@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20110107195822.39DA440467@magilla.sf.frob.com>
Date: Fri,  7 Jan 2011 11:58:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, ptrace_may_access() protects only get_wchan/eip/esp, but
> not utime/stime.

Oh, sorry.  I misread the code.  As I said, I leave it to the security
folks to decide what the appropriate constraints are.  All the mechanisms
for accessing the same information should just be consistent.  So perhaps
this is indeed fine.


Thanks,
Roland
