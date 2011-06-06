Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1FFOWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:22:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164Ab1FFOWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
References: <cover.1307292171.git.luto@mit.edu> <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
 <20110606093102.GW27166@one.firstfloor.org> <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Jun 2011 22:56:23 +0900
Message-ID: <BANLkTin5jEmUUxWUUkYn9pKzGRwcA-zRLw@mail.gmail.com>
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
To: pageexec@freemail.hu
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 7:39 PM,  <pageexec@freemail.hu> wrote:
>
> what is annoying is your covering up of security fixes on grounds that you don't want
> to help script kiddies (a bullshit argument as it were) but at the same time question
> proactive security measures (one can debate the implementation, see my other mail) that
> would *actually* prevent the same kiddies from writing textbook exploits.

Shut up unless you have any real arguments. I know you have your
hangups, and I just don't care.

Calling the old vdso "UNSAFE" as a config option is just plain stupid.
t's a politicized name, with no good reason except for your political
agenda. And when I call it out as such, you just spout the same tired
old security nonsense.

I'm happy with perhaps moving away from the fixed-address vdso, but
that does not excuse bad naming and non-descriptive crap like the
feature-removal thing, and all the insanity going on in the thread. If
the config option is about removing the legacy vdso, then CALL IT
THAT, instead of spouting idiotic and irrelevant nonsense.

                       Linus
