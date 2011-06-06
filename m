Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab1FFOHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:07:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1FFOHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:07:30 -0400
MIME-Version: 1.0
In-Reply-To: <4DECC07A.8317.124A847C@pageexec.freemail.hu>
References: <cover.1307292171.git.luto@mit.edu> <4DECA101.5994.11CF924E@pageexec.freemail.hu>
 <BANLkTikv3hyDsimi7YDVny1-1k2937NAkg@mail.gmail.com> <4DECC07A.8317.124A847C@pageexec.freemail.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Jun 2011 23:01:19 +0900
Message-ID: <BANLkTimZjqEYHt=MBBthXOoUXcorJz4J1A@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
To: pageexec@freemail.hu
Cc: Andrew Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 8:56 PM,  <pageexec@freemail.hu> wrote:
>
> it's *irrelevant*. this change you propose would go into future kernels,
> it would not affect existing ones, obviously. therefore anyone possibly
> affected would have to update his kernel first at which point they have
> no excuse to not update their libc of whatever flavour as well.

Christ.

Heard about that thing called "backwards compatibility"?

We *require* that those "future kernels" run the old unmodified binaries.

Yeah, I know you don't have that requirement, but anything that
actually wants to be considered *relevant* and actually merged into a
mainline kernel does have that requirement. So your argument is utter
crap, ignorant, and stupid.

No, we don't update any libraries for a kernel upgrade. Ever. End of story.

               Linus
