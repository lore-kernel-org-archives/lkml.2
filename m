Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1HAKEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:04:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43274 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1HAKEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:04:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110801043207.GE2203@ZenIV.linux.org.uk>
References: <1312066693.22074.50.camel@i7.infradead.org>
	<1312066923.22074.53.camel@i7.infradead.org>
	<CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
	<1312151063.18010.25.camel@i7.infradead.org>
	<20110731224834.GC2203@ZenIV.linux.org.uk>
	<20110731225801.GD2203@ZenIV.linux.org.uk>
	<1312153988.18010.39.camel@i7.infradead.org>
	<CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
	<20110801043207.GE2203@ZenIV.linux.org.uk>
Date: Mon, 1 Aug 2011 12:04:37 +0200
X-Google-Sender-Auth: diztSCGumZVHmFvTshVvYRszTM0
Message-ID: <CAMuHMdUXZw=NO-sXLWu8TMkwE-_A_sq60KUVkYZrNFqcLOALrA@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall
 exports, not SUBARCH_i386
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 06:32, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Aug 01, 2011 at 01:17:17AM +0200, richard -rw- weinberger wrote:
>> On Mon, Aug 1, 2011 at 1:13 AM, David Woodhouse <dwmw2@infradead.org> wrote:
>> > On Sun, 2011-07-31 at 23:58 +0100, Al Viro wrote:
>> >> FWIW, the next step (still not pushed there) is to move arch/um/sys-x86 to
>> >> arch/x86/um, with arch/um/os-Linux/sys-x86 becoming arch/x86/um/os-Linux,
>> >> Kconfig.x86 moving to arch/x86/um/Kconfig and Makefile-x86 - to
>> >> arch/x86/um/Makefile.defs. ?Next after that - arch/powerpc/um (and yes,
>> >> it means resurrected uml/ppc port; for now - only ppc32, since I have no
>> >> ppc64 boxen to test on).
>> >
>> > I can give you an account on a ppc64 box if that would help...
>>
>> Isn't UML on ppc broken since ages?
>
> Yes.  Resurrected is not the right word here, sorry...

Oh, what a disappointment. I really hoped it was true...

BTW, how much work would it be to port UML to ARM? Would be nice-to-have on
your Android phone, as it can provide a full Linux userspace without
requiring rooting
the phone.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
