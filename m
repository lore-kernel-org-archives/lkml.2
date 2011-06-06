Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab1FFTB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:01:59 -0400
Received: from r00tworld.com ([212.85.137.150]:52592 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab1FFTB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:01:57 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Mon, 06 Jun 2011 20:59:39 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <4DED239B.8177.13CDBA86@pageexec.freemail.hu>
In-reply-to: <20110606144414.GA30348@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>, <20110606144414.GA30348@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 21:00:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 16:44, Ingo Molnar wrote:
> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > > > Seriously. The whole patch series just seems annoying.
> > 
> > what is annoying is your covering up of security fixes on grounds 
> > that you don't want to help script kiddies (a bullshit argument as 
> > it were) but at the same time question proactive security measures 
> > (one can debate the implementation, see my other mail) that would 
> > *actually* prevent the same kiddies from writing textbook exploits.
> 
> You are mixing up several issues here, and rather unfairly so.

but it's very simple logic Ingo. it goes like 'I am not willing to
do A because it would help script kiddies but I'd rather do B that
would help script kiddies'. with A = 'disclose security bugs' and
B = 'keep the last roadblock that prevents full ASLR'.

if someone's that worried about script kiddies as Linus claims to be
(which i always called a BS argument, but let's accept here), he can't
possibly argue for keeping the vsyscall page at a fixed address around,
simple as that.

and it is for security, no other reason, else you'd have to accept a patch
that maps the vdso at a fixed address again or come up with some very
convincing arguments why the vdso must stay randomized but the vsyscall
page is fine at a fixed address (i guess neither is forthcoming but you
guys can act in surprising ways, so i'm not placing any bets ;).

> Firstly, see my other mail, there's an imperfect balance to be
> found between statistical 'proactive' measures and the incentives
> that remove the *real* bugs.

i hope i replied to this already now to your satisfaction else feel free
to elaboarte.

> Secondly, *once* a real security bug has been found the correct 
> action is different from the considerations of proactive measures. 

as i said already, you're mixing up fixing bugs and fighting exploit
techniques. apples vs. oranges.

> How can you possibly draw equivalence between disclosure policies
> and the handling of statistical security measures?

see the simple logic above.

