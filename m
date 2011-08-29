Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1H2TBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 15:01:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53732 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1H2TBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 15:01:37 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
References: <4E582577.2060805@zytor.com>
	<CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
	<4E582EAA.1040108@zytor.com>
	<CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
	<CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
	<4E584492.5090406@zytor.com>
	<CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
Date: Mon, 29 Aug 2011 21:01:37 +0200
X-Google-Sender-Auth: rfRokX_ECETJnumSEgvpr0Xfkpk
Message-ID: <CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 03:42, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> time_t really *should* be 64-bit, the same way "off_t" should be. If
> it's not, there's something wrong.

Which will break all this non-portable 32-bit-only source code x32 was invented
for in the first place?
Someone will pass a time_t or off_t and an innocent pointer to a custom
printf-alike function to format it like "%u %s" and it will go bang...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
