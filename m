Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0JUIbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:31:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37303 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab0JUIbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:31:14 -0400
Date: Thu, 21 Oct 2010 10:31:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
Message-ID: <20101021083101.GE8775@elte.hu>
References: <1287479765.9920.9.camel@marge.simson.net>
 <1287487757.24189.40.camel@marge.simson.net>
 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
 <1287511983.7417.45.camel@marge.simson.net>
 <1287514410.7368.10.camel@marge.simson.net>
 <20101020025652.GB26822@elte.hu>
 <1287648715.9021.20.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287648715.9021.20.camel@marge.simson.net>
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

> On Wed, 2010-10-20 at 04:56 +0200, Ingo Molnar wrote:
> 
> > Mind doing more of the tty->desktop renames/generalizations as Linus suggested, and 
> > resend the patch?
> 
> Here she comes.  Better/Worse?
> 
> Changes:
> - tty->autogroup.
> - only autogroup fair class tasks.
> - removed dainbramaged sleeper vruntime twiddling.
> - removed paranoid locking.
> - removed noop detatch code.

I really like the new 'autogroup scheduler' name - as we really dont want to turn 
this into anything but an intelligent grouping thing. Via the naming we can resist 
heuristics for example.

Btw., how does Xorg fare with this? Can we remove sleeper fairness for example and 
simplify other bits of the CFS logic as a side-effect?

	Ingo
