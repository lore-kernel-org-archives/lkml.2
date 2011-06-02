Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab1FBIKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 04:10:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458Ab1FBIKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 04:10:05 -0400
Date: Thu, 2 Jun 2011 10:09:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110602080937.GA5722@elte.hu>
References: <cover.1306847455.git.luto@mit.edu>
 <7e604b2dd699a30204fda3d1011f3af5a2c56572.1306847455.git.luto@mit.edu>
 <10442.1306949732@turing-police.cc.vt.edu>
 <BANLkTinKKmXYBLwc_cQBVcs-jgh_1SV6NQ@mail.gmail.com>
 <13093.1306952865@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13093.1306952865@turing-police.cc.vt.edu>
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Wed, 01 Jun 2011 13:41:56 EDT, Andrew Lutomirski said:
> 
> >> +         On a system with recent enough glibc (probably 2.14 or
> >>  +         newer) and no static binaries, you can say N without a
> >>  +         performance penalty to improve security
> >>
> >> So I checked my laptop (Fedora 16 Rawhide), and found a bunch of static binaries. The ones
> >> that look like people may care:
> 
> > The binaries will still work -- they'll just take a small performance
> > hit (~220ns on Sandy Bridge) every time they call time().
> 
> Ah. I misparsed the Kconfig help - I read it as "If you have no 
> static binaries, setting this to N doesn't introduce a performance 
> hit" (with an implied "if you have static binaries, this will hose 
> you").  Adding "Static binaries will continue to work at a very 
> small performance penalty" would probably help.

Yeah, would be nice to add that clarification. (or better yet, 
reformulate it in a way that makes it really obvious from the get 
go.)

Thanks,

	Ingo
