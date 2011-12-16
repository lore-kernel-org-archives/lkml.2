Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab1LPXQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:16:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48432 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1LPXQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:16:41 -0500
X-Authority-Analysis: v=2.0 cv=QrfcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=p7iaMJ_j78IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=6ukdl8CIM0QAT-HVtlUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324077399.23971.134.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/6] [GIT PULL] x86: Workaround for NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Date: Fri, 16 Dec 2011 18:16:39 -0500
In-Reply-To: <20111216225906.481643317@goodmis.org>
References: <20111216225906.481643317@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 17:59 -0500, Steven Rostedt wrote:

> I have the ftrace patches pretty much ready, but I would like to get
> these in under the x86 branch.

Bah, I just realized that I based it on the perf branch. Let me rebase
it on one of the tip x86 branches or even plain 3.2-rc5, and retest.

Thanks,

-- Steve


