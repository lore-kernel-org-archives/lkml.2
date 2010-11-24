Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0KXNUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:20:32 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54221 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab0KXNU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:20:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U2HkUL3gWqIhYVW8QErEPm/fU8ELQbDIHgV3qh7A3/xRQkYUkTa2tJBkE3tMuhG1qz
         UCHwtf1A9LrqjioC8Cvs8/PIDXtuKMGD0KnMmI2VzTlDewBKwAhtYPTbmhMqnrlMhYEF
         YsGnTGMWOidZbnsverRi8rzrUDMhoBID7fqjA=
MIME-Version: 1.0
In-Reply-To: <1289842201-3277-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1289842201-3277-1-git-send-email-Dinh.Nguyen@freescale.com>
Date: Wed, 24 Nov 2010 21:20:26 +0800
Message-ID: <AANLkTimN1tQee2PywyphPnAdvC8_ASgZud_F=ma_+Bde@mail.gmail.com>
Subject: Re: [PATCHv5 1/3] ARM: imx: Add core definitions for MX53
From: Richard Zhao <linuxzsc@gmail.com>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de, eric@eukrea.com,
        u.kleine-koenig@pengutronix.de, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

> diff --git a/arch/arm/mach-mx5/crm_regs.h b/arch/arm/mach-mx5/crm_regs.h
> index c776b9a..51ff9bb 100644
> --- a/arch/arm/mach-mx5/crm_regs.h
> +++ b/arch/arm/mach-mx5/crm_regs.h
> @@ -18,6 +18,9 @@
>  #define MX51_CORTEXA8_BASE     MX51_IO_ADDRESS(MX51_ARM_BASE_ADDR)
>  #define MX51_GPC_BASE          MX51_IO_ADDRESS(MX51_GPC_BASE_ADDR)
>
> +/*MX53*/
> +#define MX53_DPLL4_BASE                MX53_IO_ADDRESS(MX53_PLL3_BASE_ADDR)
> +
>  /* PLL Register Offsets */
>  #define MXC_PLL_DP_CTL                 0x00
>  #define MXC_PLL_DP_CONFIG              0x04

CCM and PLL base address are different between mx53 and mx51. Why do
you both use mx51 base address?

Thanks
Richard
