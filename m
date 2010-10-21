Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0JUHzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:55:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50402 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751208Ab0JUHzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:55:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192lZMedch2CU8TyJSGL0MnrU847aCp5lacMRWF0P
	5LdWYzT74bVt0f
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1287481381.29097.1652.camel@twins>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287480391.29097.1647.camel@twins>
	 <1287481199.24189.5.camel@marge.simson.net>
	 <1287481381.29097.1652.camel@twins>
Content-Type: text/plain
Date: Thu, 21 Oct 2010 09:55:41 +0200
Message-Id: <1287647741.9021.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 11:43 +0200, Peter Zijlstra wrote: 
> On Tue, 2010-10-19 at 11:39 +0200, Mike Galbraith wrote:
> > 
> > Yeah. I should be able to just do sched_move_task(), but it doesn't
> > currently work even with your patch, turning tty_sched on/off can lead
> > to incredible delays before you get box back.  With virgin source, it's
> > size infinity for all intents and purposes.
> 
> Ah, first feedback I've got on that patch,. but surely since you created
> one that does work we can fix my patch and use the normal path? :-)

Actually, your patch works just peachy, my fiddling with sleepers
vruntime at attach time was a dainbramaged thing to do.

	-Mike

