Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1FFKBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:01:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53367 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab1FFKBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pwAsabNrLkCk+EmhfiLrtyAW54k9v+2izLtV20/xtB9E4O/WTz8VfMRC4A0XhfnOOg
         6AATHfe6AjeYFJlO2Nb8vT9rS4Sz3FrA0aRIOb60dC9jpSuw5K3K+78d0boJm2DaCO6w
         N5nSJ8f3wVq1OPvYF6W5ORyd8fhH0Klb5fq1E=
MIME-Version: 1.0
In-Reply-To: <201106061100.38249.arnd@arndb.de>
References: <20110605071725.26517.11573.stgit@ponder>
	<201106061100.38249.arnd@arndb.de>
Date: Mon, 6 Jun 2011 12:01:37 +0200
X-Google-Sender-Auth: U0dnaK7ecqkhSgYulS3mo9sEQgI
Message-ID: <BANLkTim_hZJ=eBRcGqG89-3OjQ_NB0xECQ@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pcmcia@lists.infradead.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        "David S. Miller" <davem@davemloft.net>, Michael Buesch <mb@bu3sch.de>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Florian Fainelli <florian@openwrt.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 11:00, Arnd Bergmann <arnd@arndb.de> wrote:
> I recently looked at the directory structure in drivers/ and found a lot
> of bus drivers with very few files, plus a few bus drivers with a lot
> of files in them besides directories for non-bus specific subsystems.
>
> I think it would be good to move them into a deeper directory drivers/bus/
> if we have support from the maintainers, and it's probably better if we
> only have to move the files once to reduce the amount of churn on the
> MAINTAINERS file and any out of tree patches.
>
> Specifically, I'd like to do these moves:
>
> drivers/{ => bus}/zorro

(if we go that way in general)

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
