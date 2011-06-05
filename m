Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1FELt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 07:49:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45139 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab1FELt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 07:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=k8sV6nFwBcQcDkkb0wmyp4jiy5dGNyvkq7417/BXJmYuCODOS4C6/YTRjsUYhlAsuK
         qc++pqUaPCNp4iuHz9d1CPcAnGgbo9oga3HQ9SzunzWgDsSZ65VD/zutPJNDX+VMPLY4
         jjM4PmO9SMHv0HiaeSb0IuQjFOwsgZbcPtn2U=
MIME-Version: 1.0
In-Reply-To: <20110605075458.GA2712@tarshish>
References: <20110605071725.26517.11573.stgit@ponder>
	<BANLkTinoEQf2a65KwQZOVK_4H9DSfqybjA@mail.gmail.com>
	<20110605075458.GA2712@tarshish>
Date: Sun, 5 Jun 2011 13:49:54 +0200
X-Google-Sender-Auth: RnE19Q8moe8svtGBQElwQjasQps
Message-ID: <BANLkTi=5XLxcZiBcZT8W4Gh+Ph_BUjs-yw@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Baruch Siach <baruch@tkos.co.il>, Grant Likely <grant.likely@secretlab.ca>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 09:54, Baruch Siach <baruch@tkos.co.il> wrote:
> On Sun, Jun 05, 2011 at 01:13:28PM +0530, Jassi Brar wrote:
>> On Sun, Jun 5, 2011 at 12:48 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> > [repost: I had a typo on the spi-devel-general mailing list address]
>> >
>> > Sort the SPI makefile and enforce the naming convention spi_*.c for
>> > spi drivers.
>
> [snip]
>
>> Though the spi_ prefix seems redundant considering the files are in
>> 'spi' directory.
>> Just a thought, no objection.
>
> When looking at the list of loaded modules (e.g. in an Oops message), the name
> "spi_xilinx" is much more meaningful than just "xilinx", for example.

Plus, when dropping the prefix, spi_xilinx.ko and gpio-xilinx.ko
become the same...

So now we have spi_<name>.c (with underscore) and gpio-<name>.c (with dash)?
And other subsystems go with <name>-<type>.c instead, e.g.
drivers/mfd/wm831x-spi.c?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
