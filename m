Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab1AAGzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 01:55:48 -0500
Received: from wormhole.pha.com.au ([203.3.69.5]:50950 "EHLO mail.pha.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750887Ab1AAGzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 01:55:46 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Jan 2011 01:55:46 EST
Date: Sat, 1 Jan 2011 17:48:32 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 03/15]drivers:staging:rtl8187se:r8180_hw.h Typo change
 diable to disable.
In-Reply-To: <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1012311722580.24460@nippy.intranet>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Dec 2010, Justin P. Mattock wrote:

> The below patch fixes a typo "diable" to "disable". Please let me know if this 
> is correct or not.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/staging/rtl8187se/r8180_hw.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/r8180_hw.h b/drivers/staging/rtl8187se/r8180_hw.h
> index 3fca144..2911d40 100644
> --- a/drivers/staging/rtl8187se/r8180_hw.h
> +++ b/drivers/staging/rtl8187se/r8180_hw.h
> @@ -554,7 +554,7 @@
>  /* by amy for power save		*/
>  /* by amy for antenna			*/
>  #define EEPROM_SW_REVD_OFFSET 0x3f
> -/*  BIT[8-9] is for SW Antenna Diversity. Only the value EEPROM_SW_AD_ENABLE means enable, other values are diable.					*/
> +/*  BIT[8-9] is for SW Antenna Diversity. Only the value EEPROM_SW_AD_ENABLE means enable, other values are disabled.					*/

I think, "other values disable" was what you meant?

Finn

>  #define EEPROM_SW_AD_MASK			0x0300
>  #define EEPROM_SW_AD_ENABLE			0x0100
>  
> 
