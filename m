Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab0DFSSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:18:34 -0400
Received: from www.tglx.de ([62.245.132.106]:55683 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084Ab0DFSS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:26 -0400
Date: Tue, 6 Apr 2010 20:15:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Avi Kivity <avi@redhat.com>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
In-Reply-To: <20100406175415.3e4a57df@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1004062011070.32352@localhost.localdomain>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com> <4BBB36FA.4020008@redhat.com> <1270560931.1595.342.camel@laptop>
 <20100406145128.6324ac9a@lxorguk.ukuu.org.uk> <4BBB531A.4070500@us.ibm.com> <4BBB5C0D.8050602@redhat.com> <alpine.LFD.2.00.1004061809080.32352@localhost.localdomain> <20100406175415.3e4a57df@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010, Alan Cox wrote:

> > > IMO the best solution is to spin in userspace while the lock holder is
> > > running, fall into the kernel when it is scheduled out.
> > 
> > That's just not realistic as user space has no idea whether the lock
> > holder is running or not and when it's scheduled out without a syscall :)
> 
> Which is the real problem that wants addressing and can be addressed very
> cheaply. That would bring us up to par with 1970s RTOS environments ;)

Well, 1970's RTOSes had other features as well like preemption disable
mechanisms and other interesting stuff. I hope you're not going to
propose that next to bring us up to par with those :)

Thanks,

	tglx
