Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0F3STt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:19:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50918 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab0F3STs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=qqm+b04ztu1d72MKCmdWOH1Ux0iUFnoqEYH9s9clicpKNz9SHx9K1VFxWBIRFoZXio
         paznc4+X/eVjC5triyMHa5ESpjV+kkYO+DH+3fls/PoXnWUPfkuGwD7e8UuejH6Ubw2z
         PSvmtlEe4QoDuoEZt+EN7WnVzWDqVxL0noMjY=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Christoph Egger <siccegge@cs.fau.de>
Subject: Re: [PATCH 27/33] Removing dead IDE_PXA_CF
Date: Wed, 30 Jun 2010 20:17:28 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       Mike Rapoport <mike@compulab.co.il>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
References: <cover.1277911345.git.siccegge@cs.fau.de> <a332e637ee15cb15f7099f5dfc19a384b2bf772b.1277911346.git.siccegge@cs.fau.de>
In-Reply-To: <a332e637ee15cb15f7099f5dfc19a384b2bf772b.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006302017.28731.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 30. června 2010 18:02:32 Christoph Egger napsal(a):
> IDE_PXA_CF doesn't exist in Kconfig, therefore removing all references
> for it from the source code.

This thing would be on purpose I believe ... maybe documenting it better won't 
hurt though.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-pxa/trizeps4.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/trizeps4.c b/arch/arm/mach-pxa/trizeps4.c
> index 6968911..0acff17 100644
> --- a/arch/arm/mach-pxa/trizeps4.c
> +++ b/arch/arm/mach-pxa/trizeps4.c
> @@ -530,13 +530,9 @@ static void __init trizeps4_init(void)
>  	i2c_register_board_info(0, trizeps4_i2c_devices,
>  					ARRAY_SIZE(trizeps4_i2c_devices));
> 
> -#ifdef CONFIG_IDE_PXA_CF
> -	/* if boot direct from compact flash dont disable power */
> -	trizeps_conxs_bcr = 0x0009;
> -#else
>  	/* this is the reset value */
>  	trizeps_conxs_bcr = 0x00A0;
> -#endif
> +
>  	BCR_writew(trizeps_conxs_bcr);
>  	board_backlight_power(1);
>  }
