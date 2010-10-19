Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab0JSJkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:40:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49263 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932440Ab0JSJkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:40:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Qq19leQOQgy7fh7iDtODLbQWBjfwPoPI24ng7YE
	Js18S1miH61XIt
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1287480391.29097.1647.camel@twins>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287480391.29097.1647.camel@twins>
Content-Type: text/plain
Date: Tue, 19 Oct 2010 11:39:59 +0200
Message-Id: <1287481199.24189.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 11:26 +0200, Peter Zijlstra wrote:
> On Tue, 2010-10-19 at 11:16 +0200, Mike Galbraith wrote:
> > Greetings,
> > 
> > Comments, suggestions etc highly welcome.
> 
> You might be wanting to exclude RT tasks from the tty groups since there
> is no interface to grant them any runtime and such :-)

:)

> Also, I think tty_sched_move_task and sched_move_task() should be
> sharing lots more code -- I recently proposed a fix for
> sched_move_task() because the Android people complained, but they
> haven't replied back yet..

Yeah. I should be able to just do sched_move_task(), but it doesn't
currently work even with your patch, turning tty_sched on/off can lead
to incredible delays before you get box back.  With virgin source, it's
size infinity for all intents and purposes.

	-Mike

