Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1FHK2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:28:38 -0400
Received: from r00tworld.com ([212.85.137.150]:40304 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab1FHK2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:28:37 -0400
From: pageexec@freemail.hu
To: Andi Kleen <andi@firstfloor.org>
Date: Wed, 08 Jun 2011 12:26:49 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DEF4E69.14274.1C44F04F@pageexec.freemail.hu>
In-reply-to: <20110608100612.GJ27166@one.firstfloor.org>
References: <20110608091120.GI27166@one.firstfloor.org>, <4DEF424F.2351.1C15AD40@pageexec.freemail.hu>, <20110608100612.GJ27166@one.firstfloor.org>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 12:27:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Jun 2011 at 12:06, Andi Kleen wrote:

> > eventually may even go away as time progresses and
> > linux systems begin to fully rely on the vdso instead.
> 
> That assumes that everyone uses glibc and also updates their userland. 
> As pointed out many times that's a deeply flawed assumption.

i think the assumption is not that everyone uses glibc but that everyone
else (as in, every other libc) can simply take the necessary changes from
glibc, provided they need such changes at all (i.e., they're using the
vsyscall entry points over the vdso ones).

i frankly didn't check any of the alternatives myself (uclibc/klibc/bionic/etc)
but i can't imagine that it'd be that much harder to patch them than glibc.

as i said, this was a compromise solution but then i think you already made
it clear that you didn't even think there was a problem here to solve, so i
guess we should work that out first, if you want to ;).

