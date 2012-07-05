Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2GERdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:33:22 -0400
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:37293 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2GERdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:33:20 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 13:33:20 EDT
Date: Thu, 5 Jul 2012 20:24:21 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] Staging: xgifb: Comment cleaning.
Message-ID: <20120705172421.GA4519@blackmetal.musicnaut.iki.fi>
References: <cover.1341498465.git.magomez@igalia.com>
 <c43dc4d9658a520bc62592d51ec9b7b2a3d81fd7.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <c43dc4d9658a520bc62592d51ec9b7b2a3d81fd7.1341498465.git.magomez@igalia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 05, 2012 at 04:45:44PM +0200, Miguel Gómez wrote:
> Remove commented code and useless comments. Leave only those with relevant
> hints to the code.
> 
> Signed-off-by: Miguel Gómez <magomez@igalia.com>

Some minor comments below:

> -/*
> - * XG20, XG21, XG40, XG42 frame buffer device
> - * for Linux kernels  2.5.x, 2.6.x
> - * Base on TW's sis fbdev code.

A lot of code was copy-pasted from Thomas Winischhofer's sisfb driver,
I'm not sure if it's OK to remove the credit...?

> -		/* TW: We can't switch off CRT1 on LVDS/Chrontel
> +		/* We can't switch off CRT1 on LVDS/Chrontel
>  		 * in 8bpp Modes */
>  		if ((xgifb_info->hasVB == HASVB_LVDS) ||
>  		    (xgifb_info->hasVB == HASVB_LVDS_CHRONTEL)) {
>  			doit = 0;
>  		}
> -		/* TW: We can't switch off CRT1 on 301B-DH
> +		/* We can't switch off CRT1 on 301B-DH
>                * in 8bpp Modes if using LCD */

These could be also fixed according to multiline comment style at the
same go.

> diff --git a/drivers/staging/xgifb/vb_init.h b/drivers/staging/xgifb/vb_init.h
> index a27b4fe..be5589c 100644
> --- a/drivers/staging/xgifb/vb_init.h
> +++ b/drivers/staging/xgifb/vb_init.h
> @@ -3,4 +3,3 @@
>  extern unsigned char XGIInitNew(struct pci_dev *pdev);
>  extern struct XGI21_LVDSCapStruct  XGI21_LCDCapList[13];
>  #endif
> -
[...]
> diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
> index 9161de1..ff40247 100644
> --- a/drivers/staging/xgifb/vb_util.h
> +++ b/drivers/staging/xgifb/vb_util.h
> @@ -6,4 +6,3 @@ extern void xgifb_reg_or(unsigned long, u8, unsigned);
>  extern void xgifb_reg_and(unsigned long, u8, unsigned);
>  extern void xgifb_reg_and_or(unsigned long, u8, unsigned, unsigned);
>  #endif
> -

These changes are not really "comment cleaning".

A.
