Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab1FGXZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:25:55 -0400
Received: from r00tworld.com ([212.85.137.150]:50289 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757965Ab1FGXZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:25:52 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Wed, 08 Jun 2011 01:24:11 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <4DEEB31B.30013.19E648C8@pageexec.freemail.hu>
In-reply-to: <20110607100519.GF4133@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DED6AAC.12348.14E3578E@pageexec.freemail.hu>, <20110607100519.GF4133@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 01:24:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Jun 2011 at 12:05, Ingo Molnar wrote:

> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > you called this feature "borderline security FUD" but have yet to 
> > prove it.
> 
> No, i did not claim that this feature is "borderline security FUD", 
> at all.

so can i take it as your concession that the vsyscall feature is indeed
a security problem and it's being randomized/(re)moved for security reasons?

in that case the naming of this feature is correct and you have no reason
to call it "borderline security FUD". so make up your mind!

> That the *NAMING* is borderline security FUD. (I already applied the 
> patches before i wrote that mail, see the commit notifications on 
> lkml.)

how can the name be "borderline security FUD" but what the name refers
to not be that? you see, we name things for a reason, mostly because
we think the name has something to do with the thing it names, duh?

