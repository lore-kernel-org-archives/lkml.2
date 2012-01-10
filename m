Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2AJTch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:32:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35705 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab2AJTcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:32:35 -0500
Date: Tue, 10 Jan 2012 20:32:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] kernel freezes with latest tree
Message-ID: <20120110193222.GA26204@elte.hu>
References: <1326171444.6638.3.camel@edumazet-laptop>
 <1326171798.6638.4.camel@edumazet-laptop>
 <1326183371.6638.6.camel@edumazet-laptop>
 <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
 <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
 <1326214407.19095.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzUSMVD84acwDGC_mqBUWg-6rdy6n_BfP6up+_V3oGx7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Has anybody seen other reports like this?

No.

And something generic as the scheduler time changes ought to 
trigger widely - i've booted up thousands and thousands of 
random kernels with your merge in place - which kind of coverage 
tends to trigger generic lockups and races.

So i'd suspect either an environment dependent bug that random 
testing on a low number of specific systems cannot cover:

 - build environment dependent (compiler?) bug
 - hw environment dependent bug
 - or sw environment dependent bug

... or a mis-bisection.

Thanks,

	Ingo
