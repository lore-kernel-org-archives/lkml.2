Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2I1G1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:27:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36795 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2I1G1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <87ehlp30pd.fsf@rustcorp.com.au>
References: <5555.1348531649@warthog.procyon.org.uk>
	<87ehlp30pd.fsf@rustcorp.com.au>
Date: Fri, 28 Sep 2012 08:27:07 +0200
X-Google-Sender-Auth: nwCxrosk1DC6XIwOrZIy2ZvWblQ
Message-ID: <CAMuHMdVGfKEeGwwf-B1rukhhdXWBYfBp2MiYbHe09P6RHkUbyw@mail.gmail.com>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
        pjones@redhat.com, jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 5:46 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> You previously wrote:
>> You can't compare them that easily.  One has a FIPS-mode panic and the other
>> doesn't.  Do we want to panic if we reject an unsigned module in enforcing
>> mode when we're in FIPS mode?
>
> It's a line ball, but I think consistency wins.  Not a validly signed
> module => panic.

Just wondering, what's the advantage of doing panic over just
rejecting the module?
Panic is a DoS?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
