Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab0KPJKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:10:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56747 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab0KPJKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XYNog2+yXfhpSF2QbTaGPsC6zXtdoF3lpCGMAdu37TSiWh9Oa1Rxr8+jFZo0nUNfLf
         ZyyNmSlcf3BCiPV1MRNCMGF8/MF/+eQh++Bm8ClYO1l6AR2gLxYjmrgc6PrJdwZE6ifX
         eJeMMKtC42AJ4hxnze4/WBzTD/ELujACTERzM=
MIME-Version: 1.0
In-Reply-To: <20101116090705.GA29337@pma.sysgo.com>
References: <20101116090705.GA29337@pma.sysgo.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 16 Nov 2010 17:09:59 +0800
Message-ID: <AANLkTin6QAr7=7-59aKzunh6nQGhCKPJ11OspBtC4NHB@mail.gmail.com>
Subject: Re: suspicious code in linux/arch/arm/common/sa1111.c
To: Pavel Machek <pma@sysgo.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 5:07 PM, Pavel Machek <pma@sysgo.com> wrote:
> Hi!
>
> Is this good idea?
>
> Signed-off-by: Pavel Machek <pma@sysgo.com>

Yep, obviously was a typo.

>
> diff -ur linux.ofic//arch/arm/common/sa1111.c linux/arch/arm/common/sa1111.c
> --- linux.ofic//arch/arm/common/sa1111.c        2010-10-17 20:31:13.000000000 +0200
> +++ linux/arch/arm/common/sa1111.c      2010-11-05 10:44:17.000000000 +0100
> @@ -282,7 +312,7 @@
>        for (i = 0; i < 8; i++) {
>                sa1111_writel(ip0 ^ mask, mapbase + SA1111_INTPOL0);
>                sa1111_writel(ip0, mapbase + SA1111_INTPOL0);
> -               if (sa1111_readl(mapbase + SA1111_INTSTATCLR1) & mask)
> +               if (sa1111_readl(mapbase + SA1111_INTSTATCLR0) & mask)
>                        break;
>        }
>
>
