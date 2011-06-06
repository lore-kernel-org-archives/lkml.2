Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab1FFMtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:49:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab1FFMtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:49:15 -0400
Date: Mon, 6 Jun 2011 14:48:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to
 COMPAT_VSYSCALLS
Message-ID: <20110606124851.GA29865@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
 <20110606102419.GA837@elte.hu>
 <4DECB7E8.5549.12290923@pageexec.freemail.hu>
 <20110606124743.GB22375@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606124743.GB22375@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > [...] does that mean that you guys would accept a patch that 
> > would map the vdso at a fixed address for old times's sake? if 
> > not, on what grounds would you refuse it? see, you can't have it 
> > both ways.
> 
> You can actually do that by enabling CONFIG_COMPAT_VDSO=y.

(on 32-bit x86)

Thanks,

	Ingo
