Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab2I2Ug2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 16:36:28 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33338 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2I2Ug1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 16:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <BLU0-SMTP777C44DD0217ABB38501DE97810@phx.gbl>
References: <CAK1hOcMongS_p5+oiaqE85tEVF8mv+SCm3yb-N=Zqz4Xuz_+WA@mail.gmail.com>
	<BLU0-SMTP54F29C73A16BAB0885137A979D0@phx.gbl>
	<1348839817.2411.19.camel@dabdike.int.hansenpartnership.com>
	<BLU0-SMTP777C44DD0217ABB38501DE97810@phx.gbl>
Date: Sat, 29 Sep 2012 22:36:26 +0200
X-Google-Sender-Auth: AJHBRtmKUuT70KW4RwmgfvEu_t0
Message-ID: <CAMuHMdUWOya35KFAVDkHaRvBi5f4FiOA2DN7G+q_bmi9=dtK2Q@mail.gmail.com>
Subject: Re: parisc: orphaned asm/compat_signal.h file?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: John David Anglin <dave.anglin@bell.net>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 10:24 PM, John David Anglin
<dave.anglin@bell.net> wrote:
> Had to remove the kvm_para.h hunk because I hit this issue:
> https://lkml.org/lkml/2012/6/13/226
> Assume this is now fixed.

Unfortunately not :-(

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
