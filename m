Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2GTVGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:06:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35824 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab2GTVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:06:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120720215516.03abd164@pyramind.ukuu.org.uk>
References: <20120713141345.f71b7c01f720d616d74721dd@canb.auug.org.au>
	<20120713121053.0637219f@pyramind.ukuu.org.uk>
	<CAMuHMdWRM0y07r1nL-9fXB3nLKXMgftqhiruEeuEe4QYDA2o9Q@mail.gmail.com>
	<20120720215516.03abd164@pyramind.ukuu.org.uk>
Date: Fri, 20 Jul 2012 23:06:44 +0200
X-Google-Sender-Auth: jTxq8avEmrgzCrGCx1FUtEagvy4
Message-ID: <CAMuHMdXt2zptOB=F4suLYjoAp0k9fWPQMLdt-67pN53rD5yqaw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tty tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Daney <david.daney@cavium.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Fri, Jul 20, 2012 at 10:55 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Today's build failed because there's a new user in the MIPS tree:
>> arch/mips/cavium-octeon/serial.c
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/6739341/
>
> The version in the tree I have registers a platform device rather than
> calling into 8250 directly. That appears to be rather better mannered
> than whatever you are building.
>
> If someone has moved from the platform device could they kindly explain
> *why* ?

commit 7c507e6fe36d8e8f67a06d1f81ddde4d8ecf739f ("MIPS: Octeon: Use
device tree to register serial ports.") in linux-next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
