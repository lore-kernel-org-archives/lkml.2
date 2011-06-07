Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1FGKFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:05:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab1FGKFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:05:44 -0400
Date: Tue, 7 Jun 2011 12:05:19 +0200
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
Message-ID: <20110607100519.GF4133@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DED16C1.24309.139B86C7@pageexec.freemail.hu>
 <20110606191218.GB20123@elte.hu>
 <4DED6AAC.12348.14E3578E@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED6AAC.12348.14E3578E@pageexec.freemail.hu>
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

> you called this feature "borderline security FUD" but have yet to 
> prove it.

No, i did not claim that this feature is "borderline security FUD", 
at all.

I said, and i quote my original reply to Linus:

 |
 | > Do you have *any* reason to call this "unsafe"?
 |
 | No, there's no reason at all for that. That naming is borderline
 | security FUD and last time i saw the series i considered renaming
 | it but got distracted :-)
 |

 https://lkml.org/lkml/2011/6/6/141

That the *NAMING* is borderline security FUD. (I already applied the 
patches before i wrote that mail, see the commit notifications on 
lkml.)

Either you have basic reading comprehension problems or you are
lying deliberately, putting words into my mouth that i never said.
Which one is it?

Thanks,

	Ingo
