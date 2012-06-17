Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab2FQVPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:15:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64790 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab2FQVPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <4FDE46E4.7020009@earthlink.net>
References: <201206170841.20222.Martin@lichtvoll.de>
	<4FDDB667.4020609@earthlink.net>
	<201206171458.58462.Martin@lichtvoll.de>
	<CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com>
	<4FDE46E4.7020009@earthlink.net>
Date: Sun, 17 Jun 2012 23:15:39 +0200
X-Google-Sender-Auth: hwMeS6G4ScVVsjP8vcfxf0GIkSA
Message-ID: <CAMuHMdVEq3RrQVJF9RgyC7UH-VAcWK=9FVvOs5Hf9X1gzv8UvQ@mail.gmail.com>
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: jdow <jdow@earthlink.net>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joanne,

On Sun, Jun 17, 2012 at 11:06 PM, jdow <jdow@earthlink.net> wrote:
> I've asked Martin for a digital copy of his RDBs and what he thinks the
> partition(s) should look like. I should also be told whether the disk
> is supposed to be solely Amiga OSs or not. I gather it's not.

His RDB is attached to https://bugzilla.kernel.org/show_bug.cgi?id=43521

> (And for God's sake do NOT implement the two virus storage tools within
> the RDBs, the RDB encapsulated filesystems and the RDB encapsulated
> driver code. I worried about that potential since RDBs were first
> introduced. Oddly I never heard of them being used. So I kept quiet
> about it. These days those facilities could be extended to use signing
> and validation certificates, I suppose.)

JFYI, I used the former to store my MultiUser File System ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
