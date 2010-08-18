Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0HREUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 00:20:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56402 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0HREUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 00:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xpfNrzkWQct5jQhlaVqmox8wyo3hs2WNdMv+0wmPgC1RQtYDT0XZeophNAuRYr/+Oq
         nyQYl4vzg15Yr35FV7ksiPpk9SN6BnNDgozkQAvsCVtAwfsozFfItniPx9WRmVBzw6Xy
         WHwqZlg/CndNX4L2/0rRLiUr8p7XaivSk9uXU=
MIME-Version: 1.0
In-Reply-To: <1281670747.13407.2.camel@mola>
References: <1281670747.13407.2.camel@mola>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 18 Aug 2010 12:20:27 +0800
Message-ID: <AANLkTimUqRMjZ735CuwAHWGrkAakQG+JPiX6Rc=9gS1R@mail.gmail.com>
Subject: Re: [PATCH] pxa: fix CI_HSYNC and CI_VSYNC MFP defines
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 11:39 AM, Axel Lin <axel.lin@gmail.com> wrote:
> According to PXA3xx Processor Family Developer Manuall Vol1. section
> "Pin Descriptions and Control", PXA30x and PXA31x Processor Alternate Function
> Table shows the Alt FN 0 for GPIO51 is CI_HSYNC and for GPIO52 is CI_VSYNC.
> This patch fixes the MFP defines and also corrects the order of MFD defines.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied to 'fix'.

> ---
>  arch/arm/mach-pxa/include/mach/mfp-pxa300.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa300.h b/arch/arm/mach-pxa/include/mach/mfp-pxa300.h
> index 7139e0d..4e12870 100644
> --- a/arch/arm/mach-pxa/include/mach/mfp-pxa300.h
> +++ b/arch/arm/mach-pxa/include/mach/mfp-pxa300.h
> @@ -71,10 +71,10 @@
>  #define GPIO46_CI_DD_7         MFP_CFG_DRV(GPIO46, AF0, DS04X)
>  #define GPIO47_CI_DD_8         MFP_CFG_DRV(GPIO47, AF1, DS04X)
>  #define GPIO48_CI_DD_9         MFP_CFG_DRV(GPIO48, AF1, DS04X)
> -#define GPIO52_CI_HSYNC                MFP_CFG_DRV(GPIO52, AF0, DS04X)
> -#define GPIO51_CI_VSYNC                MFP_CFG_DRV(GPIO51, AF0, DS04X)
>  #define GPIO49_CI_MCLK         MFP_CFG_DRV(GPIO49, AF0, DS04X)
>  #define GPIO50_CI_PCLK         MFP_CFG_DRV(GPIO50, AF0, DS04X)
> +#define GPIO51_CI_HSYNC                MFP_CFG_DRV(GPIO51, AF0, DS04X)
> +#define GPIO52_CI_VSYNC                MFP_CFG_DRV(GPIO52, AF0, DS04X)
>
>  /* KEYPAD */
>  #define GPIO3_KP_DKIN_6                MFP_CFG_LPM(GPIO3,   AF2, FLOAT)
> --
> 1.7.2
>
>
>
>
