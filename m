Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab0GMP4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:56:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:32797 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753457Ab0GMP4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:56:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Uz1IMT+AUt6XVgH2I9pmY5rHGLoyic7AMNtNvPx
	xFXjX7bNJFCjJW
Subject: Re: [PATCH][RT] futex: protect against pi_blocked_on corruption
 during requeue PI -V2
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, "lkml," <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1007131348180.3321@localhost.localdomain>
References: <1278478019.10245.77.camel@marge.simson.net>
	 <alpine.LFD.2.00.1007071356480.2604@localhost.localdomain>
	 <4C3C1DCF.9090509@us.ibm.com>
	 <alpine.LFD.2.00.1007131041230.3321@localhost.localdomain>
	 <alpine.LFD.2.00.1007131222430.3321@localhost.localdomain>
	 <alpine.LFD.2.00.1007131348180.3321@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 17:57:22 +0200
Message-ID: <1279036642.5733.7.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 13:52 +0200, Thomas Gleixner wrote:
> On Tue, 13 Jul 2010, Thomas Gleixner wrote:
> > 
> > This code causes braindamage. I really wonder whether we need to
> > remove it according to the "United Nations Convention against Torture
> > and Other Cruel, Inhuman or Degrading Treatment or Punishment".
> > 
> 
> Ok, finally managed to twist my brain around it. Mike, can you give it
> a test ride ?

I'm away from box until Friday evening.  I'll test, but it'll likely be
ancient history by then.

	-Mike


