Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab1FHJDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:03:36 -0400
Received: from r00tworld.com ([212.85.137.150]:54645 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1FHJDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:03:35 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Wed, 08 Jun 2011 11:02:11 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DEF3A93.8871.1BF773E2@pageexec.freemail.hu>
In-reply-to: <20110608064857.GA6747@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>, <20110608064857.GA6747@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 11:02:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Jun 2011 at 8:48, Ingo Molnar wrote:

> > you seemed to have made a distinction, you tell me ;), [...]
> 
> I have not made any distinction at all, *you* wrote:

i asked you that question because for all this time you seemed to
have been very worked up by the fact that i called the page fault
path as not 'fast'. i thought maybe what caused your nervous reaction
and desperate attempts at trying to justify it was due to some
misunderstanding in wording, but i now see that we probably talked
about the same thing. with the exception that you *still* have not
provided any evidence for your claim. why is that Ingo? do you have
nothing to prove your single cycle 'improvemnt'? (sorry, had a
chuckle again ;).

