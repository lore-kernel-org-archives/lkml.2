Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab1JGIXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:23:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37892 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598Ab1JGIXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:23:15 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-16-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-16-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 16:22:55 +0800
Message-ID: <CAMPhdO_Ni0Dq_J1scoASejykmajXsA-kMW64cMS1ea2ACBoGEw@mail.gmail.com>
Subject: Re: [PATCH 15/26] irda/ficp: only works on some pxa models
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Samuel Ortiz <samuel@sortiz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> This driver can only be built for pxa25x and pxa27x at the moment,
> so encode that in Kconfig.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Samuel Ortiz <samuel@sortiz.org>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/net/irda/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
> index 25bb2a0..8cffd38 100644
> --- a/drivers/net/irda/Kconfig
> +++ b/drivers/net/irda/Kconfig
> @@ -373,7 +373,7 @@ config VIA_FIR
>
>  config PXA_FICP
>        tristate "Intel PXA2xx Internal FICP"
> -       depends on ARCH_PXA && IRDA
> +       depends on ARCH_PXA && IRDA && (PXA25x || PXA27x)
>        help
>          Say Y or M here if you want to build support for the PXA2xx
>          built-in IRDA interface which can support both SIR and FIR.
> --
> 1.7.5.4
>
>
