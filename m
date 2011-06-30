Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1F3JcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:32:22 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58108 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1F3JcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110630085633.GA31414@infradead.org>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
	<20110629140630.5aefdda8.rdunlap@xenotime.net>
	<BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
	<20110630080119.GA20802@infradead.org>
	<BANLkTik81kgf=g+QngnaB7gNUF+xCQdSvw@mail.gmail.com>
	<20110630085633.GA31414@infradead.org>
Date: Thu, 30 Jun 2011 11:32:14 +0200
X-Google-Sender-Auth: TqDPDVw1_SNQFaA7R4L28M0MuK4
Message-ID: <BANLkTim4SHUXQn4D9Lup4mc0i2D8D0dCUg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 10:56, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jun 30, 2011 at 10:43:47AM +0200, Geert Uytterhoeven wrote:
>> > Better fix the code to use the proper %zd specifier for printing ssize_t
>> > variables.
>>
>> We cannot, as that would break on all other platforms that use the
>> correct ssize_t.
>
> %zd is specified as the correct format for ssize_t.

And the code is already using that!
But cris overrides ssize_t to a different type than expected by the compiler.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
