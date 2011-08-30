Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1H3HAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:00:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46614 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1H3HA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:00:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzuY+U0nf58-9P5CFaYAPKMQ3fQMGGUUkjbxRRCK7=A3Q@mail.gmail.com>
References: <4E582577.2060805@zytor.com>
	<CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
	<4E582EAA.1040108@zytor.com>
	<CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
	<CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
	<4E584492.5090406@zytor.com>
	<CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
	<CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com>
	<CA+55aFzuY+U0nf58-9P5CFaYAPKMQ3fQMGGUUkjbxRRCK7=A3Q@mail.gmail.com>
Date: Tue, 30 Aug 2011 09:00:28 +0200
X-Google-Sender-Auth: Ez44gXtIsYA5ujOrwfOxiaCTO2A
Message-ID: <CAMuHMdUXw5nAsk0zYqU=fao2zgbPjg7f_LRCnr_Fa4MAQtWRWQ@mail.gmail.com>
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

On Tue, Aug 30, 2011 at 03:48, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Aug 29, 2011 at 12:01 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>>
>> Which will break all this non-portable 32-bit-only source code x32 was invented
>> for in the first place?
>
> NO. HELL NO!
>
> Guys, get a f&*king grip already!
>
> There are absolutely ZERO compatibility issues.
>
> If you want compatibility, you run traditional 32-bit x86.

Sorry, this was mainly pointed to:

"Furthermore, there are users who seem more willing to port code known to
 not be 64-bit clean to x32 than to do a whole new port."

earlier in the thread.

> If you want full 64-bit, you run standard x86-64 binaries.

Sure.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
