Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2ILH5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:57:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:32991 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab2ILH5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:57:16 -0400
MIME-Version: 1.0
In-Reply-To: <505038E8.6010309@televes.com>
References: <505038E8.6010309@televes.com>
Date: Wed, 12 Sep 2012 09:57:15 +0200
X-Google-Sender-Auth: Y1d229Ds4jjIkCI0rXYDAZiBgrY
Message-ID: <CAMuHMdXCffH84uqkcuS=Njc0JNGPowN3f7Kwi_32=D7r8OTL9A@mail.gmail.com>
Subject: Re: Linux based bootloader
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jorge Dominguez <jmadom@televes.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jorge,

On Wed, Sep 12, 2012 at 9:25 AM, Jorge Dominguez <jmadom@televes.com> wrote:
> I find link on Web that describes a module to load other linux kernel or
> bootloader with a commandline params inside a linux.
>
> Works are perform by bootloader kernel module that get kernel, initrd and
> command line params.
>
> http://www.embeddedarm.com/software/arm-linux-bootloader.php
>
> Unfortunately, this module has been developed by a private company and
> payment.
>
> All embedded developers are waiting for a module of its kind in the kernel
> but open source and would greatly facilitate the development of the kernel
> for these systems without having to flash the kernel or loaded via nfs or
> other boot method.
>
> Send this email after looking at some kernel module that can do this work.
> Would be very grateful if you could tell me something about it.
>
> I don´t subscribe to linux-kernel mailing list, Please send me a CC'ed
> response

What about kexec and kboot/petitboot?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
