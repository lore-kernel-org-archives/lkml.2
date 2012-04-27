Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277Ab2D0TO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:14:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51359 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760475Ab2D0TOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120427184528.GL6871@ZenIV.linux.org.uk>
References: <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
	<20120420160848.GG6871@ZenIV.linux.org.uk>
	<20120420164239.GH6871@ZenIV.linux.org.uk>
	<CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
	<20120420180748.GI6871@ZenIV.linux.org.uk>
	<20120423180150.GA6871@ZenIV.linux.org.uk>
	<20120424072617.GB6871@ZenIV.linux.org.uk>
	<20120426183742.GA324@redhat.com>
	<20120426231942.GJ6871@ZenIV.linux.org.uk>
	<20120427172444.GA30267@redhat.com>
	<20120427184528.GL6871@ZenIV.linux.org.uk>
Date: Fri, 27 Apr 2012 21:14:53 +0200
X-Google-Sender-Auth: kUlPW0hgCUC1mBZhbVZts0NdUtw
Message-ID: <CAMuHMdXTR1ug3sOyJ_PA0Yub2GsO5NCdAd71EX0Y9osq1ei5KQ@mail.gmail.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland McGrath <roland@hack.frob.com>, Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 20:45, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> The only comment I have,
>> 38671a3e831ed7327affb24d715f98bb99c80e56 m68k: add TIF_NOTIFY_RESUME and handle it
>> forgets to unexport do_signal().
>
> Meh...  The thing is, there are _two_ of them.  signal_mm.c and signal_no.c
> badly need merging, with common stuff moved to signal.c.  I really hate

Greg recently posted a patch to merge them:
http://www.spinics.net/lists/linux-m68k/msg04995.html

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
