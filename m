Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab1FFOok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:44:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1FFOoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:44:39 -0400
Date: Mon, 6 Jun 2011 16:44:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110606144414.GA30348@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
 <20110606093102.GW27166@one.firstfloor.org>
 <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> > > Seriously. The whole patch series just seems annoying.
> 
> what is annoying is your covering up of security fixes on grounds 
> that you don't want to help script kiddies (a bullshit argument as 
> it were) but at the same time question proactive security measures 
> (one can debate the implementation, see my other mail) that would 
> *actually* prevent the same kiddies from writing textbook exploits.

You are mixing up several issues here, and rather unfairly so.

Firstly, see my other mail, there's an imperfect balance to be
found between statistical 'proactive' measures and the incentives
that remove the *real* bugs. You have not replied to that mail of
mine so can i assume that you concur and accept my points? If yes
then why are you still arguing the same thing?

Secondly, *once* a real security bug has been found the correct 
action is different from the considerations of proactive measures. 
How can you possibly draw equivalence between disclosure policies
and the handling of statistical security measures?

Thanks,

	Ingo
