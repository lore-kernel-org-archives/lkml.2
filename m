Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab1BKAAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:00:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757328Ab1BKAAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:00:19 -0500
Date: Fri, 11 Feb 2011 00:59:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        anton@samba.org, Mike Travis <travis@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PULL] cpumask offstack finalization
Message-ID: <20110210235956.GA3231@elte.hu>
References: <201102091608.59448.rusty@rustcorp.com.au>
 <20110210124416.GE26094@elte.hu>
 <201102110802.17453.rusty@rustcorp.com.au>
 <alpine.LFD.2.00.1102102310491.31804@localhost6.localdomain6>
 <AANLkTinMsD664FiDZy2ZtVo2jtH0x7m30EyMay9REmwj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinMsD664FiDZy2ZtVo2jtH0x7m30EyMay9REmwj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And yes, next time this discussion comes up, I _will_ remove that piece-of-sh*t. 

Hey, if that's what it takes to get __deprecated removed i'll bring it up tomorrow!!
:-)

	Ingo
