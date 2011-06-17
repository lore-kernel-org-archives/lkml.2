Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1FQFBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 01:01:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50666 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab1FQFBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 01:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lB0rdkbGgNOVC3r5Lc4yKmKIMdeQn8V8rB444PW7Y+BSjopdJ4UeGUWqvShNt1iilW
         ZtQxcMyomCrCU7hV7XC29zRGPTPoGSmXPbpT8Nd/xfsdi+psduRZC0s9UbJujoQO95U2
         5JHButlX9y5mXU52DfETAqrNa7VhzU5u4MI/c=
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.1106171337170.191@ibook.intranet>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<BANLkTimebx56-Wb5JPWxYVnND9gG8OVdsQ@mail.gmail.com>
	<BANLkTin+gp2Cnxj8kHbHRmuoEgyDR8YeaQ@mail.gmail.com>
	<BANLkTik5-H1fc2rk3QrwvQiF=7fELmE2CA@mail.gmail.com>
	<alpine.OSX.2.00.1106171337170.191@ibook.intranet>
Date: Fri, 17 Jun 2011 07:01:30 +0200
X-Google-Sender-Auth: L645fEIOsaDhl9epb2nwhJzKPao
Message-ID: <BANLkTi=8eC3aiUL8fhGfQHW0xBrLF2TBCA@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 05:45, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Thu, 16 Jun 2011, Geert Uytterhoeven wrote:
>> On Wed, Jun 15, 2011 at 21:44, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > On Sat, Jun 4, 2011 at 19:56, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> >> On Sat, May 28, 2011 at 20:32, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> >>
>> >> It works on Amiga now, too. It can still use some optimizations in
>> >> the irq_{enable,disable,ack,mask,mask_ack,unmask} area, as my
>> >> BogoMIPS rating dropped by ca 2.5% and is now under 16, for a 25 MHz
>> >> 68040.
>> >
>> > Seems like everything (Atari/ARAnyM and Amiga) still works when using
>> > handle_simple_irq instead of handle_level_irq. As a bonus, BogoMIPS is
>> > above 16 again.
>
> Your bogomips benchmark would be the best-case penalty, right?
>
> Have you tried say, sending a ping flood to measure throughput and
> latency?

No, I haven't compared network performance.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
