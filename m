Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1FHJg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:36:59 -0400
Received: from r00tworld.com ([212.85.137.150]:38553 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab1FHJg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:36:58 -0400
From: pageexec@freemail.hu
To: Andi Kleen <andi@firstfloor.org>
Date: Wed, 08 Jun 2011 11:35:11 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Ingo Molnar <mingo@elte.hu>, Andrew Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DEF424F.2351.1C15AD40@pageexec.freemail.hu>
In-reply-to: <20110608091120.GI27166@one.firstfloor.org>
References: <20110608064857.GA6747@elte.hu>, <4DEF3A93.8871.1BF773E2@pageexec.freemail.hu>, <20110608091120.GI27166@one.firstfloor.org>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 11:35:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Jun 2011 at 11:11, Andi Kleen wrote:

> There's clear evidence that any kind of exception in gettimeofday()/time()
> is too slow. A few years ago gtod() had CPUID which lead to intercepts
> with many hypervisors. This turned out to be a unacceptable slowdown,
> so it was fixed,

yes, i don't think anyone claimed any performance improvements from moving
away from the vsyscall page into taking exceptions ;). i think everyone
considers this as a stop-gap compatibility measure only that will be less
and less relevant and eventually may even go away as time progresses and
linux systems begin to fully rely on the vdso instead.

