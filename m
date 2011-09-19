Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1ISB05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 21:26:57 -0400
Received: from mail-wy0-f170.google.com ([74.125.82.170]:46953 "EHLO
	mail-wy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab1ISB0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 21:26:55 -0400
MIME-Version: 1.0
In-Reply-To: <1316378130.31335.32.camel@edumazet-laptop>
References: <20110918.022125.1554085675403900813.davem@davemloft.net>
 <CA+55aFxc1tMCXKBV33PVD5BybTLBpfJAEcObvoQwbwqbKOsp7g@mail.gmail.com>
 <20110918192333.GA1641@x4.trippels.de> <1316375164.31335.18.camel@edumazet-laptop>
 <20110918194818.GB1641@x4.trippels.de> <CA+55aFwmwYXzC_4q+XuEAx3ta6U-jf=NvMcAc-J+4DBxLm8Efg@mail.gmail.com>
 <1316378130.31335.32.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Sep 2011 18:26:33 -0700
X-Google-Sender-Auth: MnqsHew-_dCpmOkZZlje_8fLTDQ
Message-ID: <CA+55aFzHOUaub9WJ7L_LGEGGkKdW-h3eV0MaUsCjdmUBKDGe_w@mail.gmail.com>
Subject: Re: [GIT] Networking
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 1:35 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> [PATCH] tcp: fix build error if !CONFIG_SYN_COOKIE
>
> commit 946cedccbd7387 (tcp: Change possible SYN flooding messages)
> added a build error if CONFIG_SYN_COOKIE=n

Christ Eric, you clearly didn't even compile-test this one either.

Which is pretty bad, considering that the whole and only *point* of
the patch is to make it compile.

The config option is CONFIG_SYN_COOKIES (with an 'S' at the end), but
your patch has 'CONFIG_SYN_COOKIE' (without the S).

Which means that now it doesn't compile when syncookies are *enabled*.

I really wanted to release -rc7 today. But no way am I applying these
kinds of totally untested patches. Can you guys please get your act
together?

PLEASE?

Stop with the "this might just work" crap. Because -rc7 is just too
late to dick around like that.

                       Linus
