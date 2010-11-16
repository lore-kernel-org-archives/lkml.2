Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0KPR2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:28:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab0KPR2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:28:18 -0500
Date: Tue, 16 Nov 2010 18:28:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116172804.GA9930@elte.hu>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289922108.5169.185.camel@maggy.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,FUZZY_VPILL autolearn=no SpamAssassin version=3.2.5
	0.7 FUZZY_VPILL            BODY: Attempt to obfuscate words in spam
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > Exactly. And this means we can _only_ assume it can't go away if 
> > autogroup_move_group() can see us on ->thread_group list.
> 
> Aha!

Mike,

Mind sending a new patch with a separate v2 announcement in a new thread, once you 
have something i could apply to the scheduler tree (for a v2.6.38 merge)?

You sent a couple of iterations in this discussion and i'd rather not fish out the 
wrong one.

Thanks,

	Ingo
