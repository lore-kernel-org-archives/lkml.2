Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0FAG0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:26:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab0FAG0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:26:23 -0400
Date: Tue, 1 Jun 2010 08:25:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Alexander Viro <viro@ftp.linux.org.uk>
Cc: tytso@mit.edu, Alex Buell <alex.buell@munted.org.uk>,
       Mailing Lists - Kernel Developers 
	<linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35 release
 candidates
Message-ID: <20100601062540.GA31131@elte.hu>
References: <1275347969.29006.5.camel@lithium.local.net>
 <20100601041028.GB4426@thunk.org>
 <AANLkTikRoff0zK-o8W4Wb_MveGibxlOG8mnrQMBtYZOY@mail.gmail.com>
 <20100601061749.GA26705@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601061749.GA26705@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3699]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Is lacking pretty much all essential pieces of information which are 
> required for reverts:
> 
>  - it has no description about who reported the bug.

In fact it was _bisected_ by Eric Paris, so a Bisected-by tag is a must.

Eric is a nice guy and i'm sure wont complain about this, but i can tell it 
with a 100% certainty that to most testers and developers bisecting bugs is a 
tiresome and error-prone process that involves quite a bit of work.

Bisecting a bug is often more work to do than the work which went into the 
original commit and the revert, combined.

So if we want more people to test our commits then the least we can do is to 
credit testers by making proper use of the Reported-by and Bisected-by tags.

	Ingo
