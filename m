Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab2JHAYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:24:23 -0400
Received: from r00tworld.com ([212.85.137.150]:58403 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab2JHAYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:24:20 -0400
From: "PaX Team" <pageexec@freemail.hu>
To: Ard Biesheuvel <ard.biesheuvel@gmail.com>
Date: Mon, 08 Oct 2012 02:23:50 +0200
MIME-Version: 1.0
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
Reply-to: pageexec@freemail.hu
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>,
        spender@grsecurity.net
Message-ID: <50721D16.9006.14F512C3@pageexec.freemail.hu>
In-reply-to: <CAKFga-erNuJ8_aLtd1b0JS1YwX1LrsCEJjEeOT67V0AqLHj_SQ@mail.gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>, <50702DF0.32447.D66E777@pageexec.freemail.hu>, <CAKFga-erNuJ8_aLtd1b0JS1YwX1LrsCEJjEeOT67V0AqLHj_SQ@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 08 Oct 2012 02:24:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Oct 2012 at 9:43, Ard Biesheuvel wrote:

> 2012/10/6 PaX Team <pageexec@freemail.hu>:
> > sadly, this is not true at all, for multiple reasons:
> >
> .. snip ...
> >
> > cheers,
> >   PaX Team
> >
> 
> So can I summarize your position as that there is no merit at all in
> the ability to inhibit future permissions of existing mappings?

i believe i answered this in the previous mail already:

> there's certainly a point (i've been doing it for 12 years now), but to
> make an mprotect flag into an actual security feature, it had better pass
> simple tests, such as non-circumventability. any method relying on
> userland playing nice is already suspect of being the wrong way and right
> now i don't see how PROT_FINAL could be used for actual security.

so if PROT_FINAL wants to be useful, you'd have to present a case of
how it does something useful *while* an exploited userland cannot get
around it. in fact i think i already told you that presenting your own
use case in more detail (read: source code, policy, etc) would be a
great step in 'selling the idea'. the fact that you seem to be reluctant
to follow up on this leaves me somewhat uneasy as it may be the sign
of a proprietary vendor's trying to push some code into mainline that
nobody else has a clear idea how it'd benefit the rest of us. you see,
you're asking for a change in a system call, which is a very important
boundary for kernel developers as they'll have to maintain it indefinitely.
so the burden is on you to prove that either this is the only way to
implement a useful feature or at least it is the optimal way as opposed
to other approaches. i suggested you ways to both attack the initially
presented concept and also how it may be improved, but i got no answers
to them yet.

cheers,
  PaX Team

