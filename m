Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144Ab1IOPyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:54:41 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:32943 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934124Ab1IOPyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:54:40 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Sep 2011 11:54:40 EDT
MIME-Version: 1.0
In-Reply-To: <CAObL_7E0iyinOyXU=uQHyQN+TBNmVVB89r_hQUb8LTqJ2ix_5A@mail.gmail.com>
References: <web-606439650@zbackend1.aha.ru> <CA+55aFwyC7s=YK10Wkpr+GzdukXp-JUtf_=MgWcrhBOtTg4eTg@mail.gmail.com>
 <web-606798161@zbackend1.aha.ru> <CA+55aFwBuySWa2VErrfud_SFqyfT5ib+Qfq9gWBaBz=cQ6VcHg@mail.gmail.com>
 <web-606831561@zbackend1.aha.ru> <CAObL_7F2Pu0K1Oe3oLe5Pef2kaGE8vdO2qgfc0KEt8TJdUaOWg@mail.gmail.com>
 <CAObL_7E0iyinOyXU=uQHyQN+TBNmVVB89r_hQUb8LTqJ2ix_5A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Sep 2011 08:47:19 -0700
X-Google-Sender-Auth: GjAYqw17GSZsP8E7flS3GpNCjlw
Message-ID: <CA+55aFzay+U5JA0Q6vdjmV73yG0OUXnO_zi6Q0c6iTkmozSSiw@mail.gmail.com>
Subject: Re: 3.1-rc6 boot problem reason searching
To: Andrew Lutomirski <luto@mit.edu>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/15 Andrew Lutomirski <luto@mit.edu>:
>
> In the mean time, I'll see if I can reproduce the crash in qemu by
> playing with -cpu.

Note that Werner doesn't actually have a i486 CPU - the i686 kernel
works fine for him. So you don't need an old CPU for the problem, you
just need to compile *for* an old CPU. He wants to support i486-class
machines because he supports a lot of old hardware.

Werner, btw, what compiler are you using? For gcc-4.5+ we use a
different magic inline asm than for older compilers..

                  Linus
