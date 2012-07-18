Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2GRTzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 15:55:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37948 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab2GRTzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 15:55:45 -0400
MIME-Version: 1.0
In-Reply-To: <50071014.6040301@redhat.com>
References: <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com>
 <20120710101018.GE15120@arm.com> <yw1x8vekd309.fsf@unicorn.mansr.com>
 <CA+55aFxL6uEre-c=JrhPfts=7BGmhb2Js1c2ZGkTH8F=+rEWDg@mail.gmail.com>
 <20120717221839.GA4856@arm.com> <1342564536.1898.1.camel@joe2Laptop>
 <5006207D.1010708@jonmasters.org> <20120718102712.46b8d7ff@adria.ausil.us>
 <20120718171426.GA4240@arm.com> <50071014.6040301@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jul 2012 12:55:24 -0700
X-Google-Sender-Auth: oKDsxZzdb591jgFZDHd7_YrJYWQ
Message-ID: <CA+55aFwr47UBoi8=i8523KnZQzOt0WB_MsOTpzVOKpsJo7PsPg@mail.gmail.com>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
To: Jon Masters <jcm@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Dennis Gilmore <dennis@ausil.us>, Joe Perches <joe@perches.com>,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 12:35 PM, Jon Masters <jcm@redhat.com> wrote:
>
> So we should think with a
> mindset of 2-3 years from now rather than where we were yesterday.

Why do you think aarch64 would be a better name 2-3 years from now?

And why do you think ARM management magically has good taste? They got
the PAE thing wrong too. They literally copied everything Intel did
*wrong* in this area, and we know it was wrong even with *more* than
2-3 years of hind-sight.

 "the one who does not remember history is bound to live through it again"
    - Santayana

Seriously. We've gone through exactly this on the x86 side. Your "I'm
sure it will be better in 2-3 years" has nothing to back it up. And
no, stupid marketing decisions by companies do *not* suddenly turn out
to be smart things a few years later.

              Linus
