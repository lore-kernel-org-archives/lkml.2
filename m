Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab1AWPQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:16:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab1AWPQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:16:05 -0500
Date: Sun, 23 Jan 2011 16:15:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Christian Kujau <christian@nerdbynature.de>,
        Michael Witten <mfwitten@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: 'autogroup' sched code KILLING responsiveness
Message-ID: <20110123151556.GA15236@elte.hu>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com>
 <alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
 <20110123145429.GA2523@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110123145429.GA2523@zhy>
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


* Yong Zhang <yong.zhang0@gmail.com> wrote:

> On Sun, Jan 23, 2011 at 02:50:08AM -0800, Christian Kujau wrote:
> > On Fri, 21 Jan 2011 at 10:20, Michael Witten wrote:
> > > With that code in place, a resource-intensive activity (such as
> > > compiling the Linux kernel) causes my computer to become
> > > unresponsive for many seconds at a time; the entire screen
> > > does not refresh, typed keys are dropped or are handled very
> > > late, etc (even in Linux's plain virtual consoles).
> > 
> > Unfortunately, I'd like to add a "me too". 2.6.38-rc1 behaves fine, but 
> > with CONFIG_SCHED_AUTOGROUP=y and doing I/O and CPU intensive work (git 
> > prune/git repack on a Linux git tree), system load goes up to ~13 and 
> > becomes unresponse for some time too. This even happens when I start the 
> > jobs with nice -n10.
> > 
> > Without CONFIG_SCHED_AUTOGROUP enabled and doing the same work,
> > systemload goes up to 1 or maybe 2.
> > 
> > I'm on UP as well (PowerPC G4), disabling CONFIG_SCHED_AUTOGROUP helps 
> > here too.
> 
> I think below patch will fix it.

Christian, Michael, can you confirm that this and the second patch fixes the 
interactivity bug for you? If yes then i'd like to apply and send this fix to Linus 
ASAP.

Thanks,

	Ingo
