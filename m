Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1LPHDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 02:03:33 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55266 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1LPHDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 02:03:32 -0500
MIME-Version: 1.0
In-Reply-To: <201112152137.29195.me@danielpalmer.co.uk>
References: <201112152137.29195.me@danielpalmer.co.uk>
Date: Fri, 16 Dec 2011 08:03:30 +0100
X-Google-Sender-Auth: xZ9LKqyRUCy2hfBQ7x7rZWJlXF0
Message-ID: <CAMuHMdU+VCVxnawb8DHmZp1EfBGW6T5D0WyXRXpo8bj1bJZ+pg@mail.gmail.com>
Subject: Re: Porting m68k/nommu to a new board.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Daniel Palmer <me@danielpalmer.co.uk>
Cc: linux-kernel@vger.kernel.org, "Linux/m68k" <linux-m68k@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added CCs.

On Fri, Dec 16, 2011 at 06:37, Daniel Palmer <me@danielpalmer.co.uk> wrote:
> Hi,
>
> I'm building a custom machine based around a 68sec000 (Fully static 68ec000).
> The "board" is a bunch of parts at the moment but I have written a workable
> simulator for the machine which I am using as a testbed for testing things
> like my custom video, DMA controller etc before creating the hardware versions
> in VHDL.
>
> I'm interested in getting mmu-less m68k linux (what used to be known as
> uclinux I guess, seems to be known as m68k/nommu now) running on the simulator
> and later on the real hardware.
>
> From what I can tell the nommu m68k port is still active. But does it actually
> work? All the details on similar hardware (like the older Palm pilots, Atari
> machines) is pretty ancient, around 2.0. Does anyone have a machine running a
> recent kernel? Were there issues getting it running?
>
> I did a bit of digging in the source and doesn't look like it should be too
> difficult to add the specifics for my machine.. I have a 16550 style UART
> emulated for I/O so I don't need to write a framebuffer driver at the moment.
> I'm open to any suggestions people have on how to approach this though.
>
>
> Please CC me as I'm not subscribed.
>
> Thanks,
>
> Daniel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
