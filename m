Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325Ab1IKTBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 15:01:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41861 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab1IKTBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 15:01:17 -0400
MIME-Version: 1.0
In-Reply-To: <201109111853.20530.Martin@lichtvoll.de>
References: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com>
	<201109111853.20530.Martin@lichtvoll.de>
Date: Sun, 11 Sep 2011 21:01:16 +0200
X-Google-Sender-Auth: tuGmdRDKFgdLVVYoXig_97jtrhY
Message-ID: <CAMuHMdUC0bR+SF0oLHb3JYQLyg2y_imak5Ns7pksqvXVha8X6A@mail.gmail.com>
Subject: Re: graceful handling of removing a plugable storage device that is
 being written to
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Hin-Tak Leung <hintak_leung@yahoo.co.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 18:53, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Frankly, I never tried this on AmigaOS. I know that AmigaOS expects the
> exact same floppy disk to be inserted again. Only the same name isn´t
> enough. But I have no idea, what AmigaOS would have done, when I inserted

Are you sure the volume name wasn't enough?
For most things, it relied on the volume name, that's how you could map
floppy names to hard drive directories using assigns.

> the disk into another Amiga, did something there and then insert it into
> the Amiga with the notification and pressed "okay". Probably it would have
> eaten the disk then.

Most probably.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
