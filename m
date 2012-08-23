Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab2HWKrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:47:12 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50445 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933435Ab2HWKrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com>
References: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com>
Date: Thu, 23 Aug 2012 12:47:07 +0200
X-Google-Sender-Auth: jcMUFu1b7I9bMsANXSqqI3J5wmw
Message-ID: <CAMuHMdUo5UPLtUhf6_GafMj_kEnM25k+XYszdwsGwkGyCUC6zw@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add support to broadcom 5222 PHY
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 2:18 PM, Stany MARCEL
<stany.marcel@novasys-ingenierie.com> wrote:
> Signed-off-by: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
> ---
>
>  This driver is an adaption of the one given by freescale for kernel 2.6.25.
>
>  Tested with kernel 3.4.8 with arch/m68k backported from linux-m68k head
>  2 FEC configured with shared phy
>
>  drivers/net/phy/Kconfig        |    7 +-
>  drivers/net/phy/Makefile       |    1 +
>  drivers/net/phy/broadcom522x.c |  171 ++++++++++++++++++++++++++++++++++++++++

This patch and "[PATCH 3/3] Add support to M54xx DMA FEC Driver" need to go
through the netdev tree, or collect acks there.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
