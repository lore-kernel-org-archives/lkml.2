Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab0DFQvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:51:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34550 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756394Ab0DFQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:51:00 -0400
Date: Tue, 6 Apr 2010 17:54:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Avi Kivity <avi@redhat.com>, Darren Hart <dvhltc@us.ibm.com>,
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
Message-ID: <20100406175415.3e4a57df@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1004061809080.32352@localhost.localdomain>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
	<4BBA5305.7010002@redhat.com>
	<4BBA5C00.4090703@us.ibm.com>
	<4BBA6279.20802@redhat.com>
	<4BBA6B6F.7040201@us.ibm.com>
	<4BBB36FA.4020008@redhat.com>
	<1270560931.1595.342.camel@laptop>
	<20100406145128.6324ac9a@lxorguk.ukuu.org.uk>
	<4BBB531A.4070500@us.ibm.com>
	<4BBB5C0D.8050602@redhat.com>
	<alpine.LFD.2.00.1004061809080.32352@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > IMO the best solution is to spin in userspace while the lock holder is
> > running, fall into the kernel when it is scheduled out.
> 
> That's just not realistic as user space has no idea whether the lock
> holder is running or not and when it's scheduled out without a syscall :)

Which is the real problem that wants addressing and can be addressed very
cheaply. That would bring us up to par with 1970s RTOS environments ;)

Alan
