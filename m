Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1IKJFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 05:05:43 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:43212 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1IKJFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 05:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110911142334.8df995a097763cd10f780f00@canb.auug.org.au>
References: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au>
	<20110825140820.GA9126@kroah.com>
	<4E56689D.3080202@freescale.com>
	<20110826015111.49af16f792d5554fd931d230@canb.auug.org.au>
	<CACqU3MUs_97=MuuKAjr-LeUT7kSRxtzSntwUeKeeH4n8s7SSGg@mail.gmail.com>
	<20110826103932.1626f1c5542b660bcd1b24aa@canb.auug.org.au>
	<CACqU3MVbKJw5VVqnz+gfLDnQEDu9Lv4xV+7RvdD4ZbetGu79WQ@mail.gmail.com>
	<20110911142334.8df995a097763cd10f780f00@canb.auug.org.au>
Date: Sun, 11 Sep 2011 11:05:40 +0200
X-Google-Sender-Auth: oz0GZgAW6CPasbR4igabbKl-NpM
Message-ID: <CAMuHMdWvN_VumsvTxam6hb-NQ0N=any8kiLoiWZ2unBLuZMy4g@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (tty tree related)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaud,

On Sun, Sep 11, 2011 at 06:23, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Fri, 26 Aug 2011 11:47:40 -0400 Arnaud Lacombe <lacombar@gmail.com> wrote:
>> Couldn't all the error log be public, rotated over a 7 iteration
>> period ? That would be fair to everyone.
>
> See http://kisskb.ellerman.id.au/linux-next (as stated in all my release
> emails).

And if you want to analyze the results, you can use the scripts I use
to create the
regression/improvement reports for tagged Linux releases.
While it would be nice to have the same for linux-next releases, I
unfortunately don't
have the time for that, as there's still some manual work involved.

http://www.spinics.net/lists/linux-next/msg11040.html

You can get the scripts referenced in my email above from any kernel.org mirror,
e.g. ftp://ftp.belnet.be/mirrors/ftp.kernel.org/pub/linux/kernel/people/geert/linux-log/.
They may not be the latest version, though, have to check/fix when
master.kernel.org
is back.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
