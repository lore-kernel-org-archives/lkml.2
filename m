Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab1ETOmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:42:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54237 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123Ab1ETOmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ifJUHvUAwQRRp9ix6WXu3lACJD95cjMVN82f5G0/zKEWw/tZxQ3uuEhlklaFCsICax
         uWoctH6n1lPeAuxYdZH7uvDeKrR3QrtJW8K1weyd2jCENPaPpU2L3GzPJrBwBoi1epPE
         bgQDje8W9EwYkfORifY7EEYCZDbG/ry0vA5bk=
MIME-Version: 1.0
In-Reply-To: <1305855298.1465.19.camel@gandalf.stny.rr.com>
References: <1305855298.1465.19.camel@gandalf.stny.rr.com>
Date: Fri, 20 May 2011 16:42:34 +0200
X-Google-Sender-Auth: rf_SPIosn9lsYbvybl5XerrVEMY
Message-ID: <BANLkTim0jCi-aE2fQ84HfwpD9mAZzfwfaw@mail.gmail.com>
Subject: Re: [RFC][PATCH] extable: Make sure all archs define _sdata
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "JamesE.J.Bottomley" <jejb@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 03:34, Steven Rostedt <rostedt@goodmis.org> wrote:
> Can I get an Acked-by (or comment) from the following Maintainers:

>  m68k

>  arch/m68k/kernel/vmlinux-std.lds  |    2 ++
>  arch/m68k/kernel/vmlinux-sun3.lds |    1 +

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
