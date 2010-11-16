Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0KPRmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:42:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47260 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756081Ab0KPRmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:42:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX189szFmbIM9/x2POWbv3l4kvq88tggUTrh695pnXu
	UR246nspQ6sfyO
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101116172804.GA9930@elte.hu>
References: <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <20101116130413.GA29368@redhat.com>
	 <1289917109.5169.131.camel@maggy.simson.net>
	 <20101116150319.GA3475@redhat.com>
	 <1289922108.5169.185.camel@maggy.simson.net>
	 <20101116172804.GA9930@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 10:42:01 -0700
Message-ID: <1289929321.5169.218.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 18:28 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > Exactly. And this means we can _only_ assume it can't go away if 
> > > autogroup_move_group() can see us on ->thread_group list.
> > 
> > Aha!
> 
> Mike,
> 
> Mind sending a new patch with a separate v2 announcement in a new thread, once you 
> have something i could apply to the scheduler tree (for a v2.6.38 merge)?

Will do.  (v3->936 became wider than expected;)

	-Mike

