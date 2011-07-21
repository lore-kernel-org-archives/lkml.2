Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1GUTFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:05:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39506 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1GUTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:05:42 -0400
Date: Thu, 21 Jul 2011 21:05:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] iMX28: Fix emi_ddr_open pinmux
Message-ID: <20110721190536.GC16561@pengutronix.de>
References: <1311264490-5485-1-git-send-email-marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1311264490-5485-1-git-send-email-marek.vasut@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 06:08:10PM +0200, Marek Vasut wrote:
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
>  arch/arm/mach-mxs/include/mach/iomux-mx28.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-mxs/include/mach/iomux-mx28.h b/arch/arm/mach-mxs/include/mach/iomux-mx28.h
> index f50fefd..1a95ecd 100644
> --- a/arch/arm/mach-mxs/include/mach/iomux-mx28.h
> +++ b/arch/arm/mach-mxs/include/mach/iomux-mx28.h
> @@ -203,7 +203,7 @@
>  #define MX28_PAD_EMI_WEN__EMI_WEN			MXS_IOMUX_PAD_NAKED(6, 21, PAD_MUXSEL_0)
>  #define MX28_PAD_EMI_CE0N__EMI_CE0N			MXS_IOMUX_PAD_NAKED(6, 22, PAD_MUXSEL_0)
>  #define MX28_PAD_EMI_CE1N__EMI_CE1N			MXS_IOMUX_PAD_NAKED(6, 23, PAD_MUXSEL_0)
> -#define MX28_PAD_EMI_CKE__EMI_CKE			MXS_IOMUX_PAD_NAKED(6, 24, PAD_MUXSEL_0)
> +#define MX28_PAD_EMI_CKE__EMI_CKE			MXS_IOMUX_PAD_NAKED(6, 26, PAD_MUXSEL_0)
In my version of the i.MX28 Reference Manual (Rev. 1, 2010) pin24 is
correct. So if you're still convinced that 26 is correct you should point
out in the commit log that the Reference Manual is wrong and why you're
convinced it really is.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
