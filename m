Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0GAC4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 22:56:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35361 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0GAC4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 22:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=H35fyxg+5k+wd9mE9KV7J18M7z1DF/9J/o3pUNHJeVaJH8yTkRLxjsa5YJ2tH4hEt1
         0Nptdb7n+TD21dvTcx437HbC1eRRpoRMxaDmSAcbX8IGRN8SYIC3ExgGZ69cxufEp1Tv
         75IcrQ6Og9Sjo2tHnBolVLYZ7mvoFwjN6KoCc=
MIME-Version: 1.0
In-Reply-To: <a332e637ee15cb15f7099f5dfc19a384b2bf772b.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de> <a332e637ee15cb15f7099f5dfc19a384b2bf772b.1277911346.git.siccegge@cs.fau.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 1 Jul 2010 10:56:31 +0800
Message-ID: <AANLkTikXk-NPcDlf0lCSbf8HYHfoZoWh-7bnQar80UMC@mail.gmail.com>
Subject: Re: [PATCH 27/33] Removing dead IDE_PXA_CF
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Rapoport <mike@compulab.co.il>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Marek Vasut <marek.vasut@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de,
       Jurgen Schindele <linux@schindele.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 12:02 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
> IDE_PXA_CF doesn't exist in Kconfig, therefore removing all references
> for it from the source code.
>
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

Include Jurgen though, in case he has any idea.

> ---
>  arch/arm/mach-pxa/trizeps4.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/trizeps4.c b/arch/arm/mach-pxa/trizeps4.c
> index 6968911..0acff17 100644
> --- a/arch/arm/mach-pxa/trizeps4.c
> +++ b/arch/arm/mach-pxa/trizeps4.c
> @@ -530,13 +530,9 @@ static void __init trizeps4_init(void)
>        i2c_register_board_info(0, trizeps4_i2c_devices,
>                                        ARRAY_SIZE(trizeps4_i2c_devices));
>
> -#ifdef CONFIG_IDE_PXA_CF
> -       /* if boot direct from compact flash dont disable power */
> -       trizeps_conxs_bcr = 0x0009;
> -#else
>        /* this is the reset value */
>        trizeps_conxs_bcr = 0x00A0;
> -#endif
> +
>        BCR_writew(trizeps_conxs_bcr);
>        board_backlight_power(1);
>  }
> --
> 1.7.0.4
>
>
