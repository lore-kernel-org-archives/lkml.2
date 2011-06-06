Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1FFOwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:52:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46391 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab1FFOwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:52:44 -0400
Date: Mon, 6 Jun 2011 16:52:15 +0200
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
Message-ID: <20110606145215.GB30348@elte.hu>
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

> On 6 Jun 2011 at 11:31, Andi Kleen wrote:
>
> > and assumes everyone is using glibc which is just wrong.
> 
> the libc is irrelevant, they can all be fixed up to use the vdso 
> entry points if they haven't been doing it already. already 
> deployed systems will simply continue to use their flawed kernel 
> and libc, they're not affected.

Correct, the libc is irrelevant here really - a distro will obviously 
enable or disable CONFIG_COMPAT_VSYSCALL=y based on the type and 
version of libc it is using.

This has been pointed out to Andi before.

Unfortunately Andi has been spouting nonsense in this thread without 
replying to mails that challenge his points, such as:

         http://marc.info/?l=linux-kernel&m=130686838202409
    and: http://marc.info/?l=linux-kernel&m=130686827002311
    and: http://marc.info/?l=linux-kernel&m=130687014804697

Thanks,

	Ingo
