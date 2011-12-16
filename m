Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563Ab1LPTCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:02:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760537Ab1LPTCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:02:08 -0500
Subject: Re: [PATCH 4/15] vub300: fix module parameter.
From: Tony Olech <tony.olech@elandigitalsystems.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: tony@olech.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <871us6tu0d.fsf@rustcorp.com.au>
References: <871us6tu0d.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 19:02:02 +0000
Message-ID: <1324062122.2302.5.camel@study-2>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:lbCloN9S3rEtl83UzLTKw0Ij6mVGgjqh7AqZG1LjGnc
 n4iGcf3zc3UGSQvHrAoYpUu9ao2GvVNpMlWHPgiKtgIJ/UZtrh
 nOxZoRrh64KsoQHT1gy4ca4nBgrEBREJHGfMEiUC4OSq5WR0s6
 CJwLxrOHPVpys3n0Noe306k1ht+dlT64MqLs7dF2efoddwmjgi
 8IYic44QBVYWh5XunagW/giVBcnDjcCP0JJ02Aw8VPN8eXFXb/
 wga6/10hO2YVbKdsd+gXyT0dT89n9q6K52KqVkAcsYU1Zlvtxp
 Cpdo35w2dcicBAN0n6U5ELNL8siZ6e563Cbf5J0C87bH3JCuUE
 Xh6pLbJ11/gBCltJfry7wZ5ONggOvUsXLyuPRz5iE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You are right.
I don't know how that slipped through
Tony Olech

On Thu, 2011-12-15 at 13:34 +1030, Rusty Russell wrote:
> You didn't mean this to be a bool.
> 
> Cc: Tony Olech <tony.olech@elandigitalsystems.com>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/mmc/host/vub300.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
> --- a/drivers/mmc/host/vub300.c
> +++ b/drivers/mmc/host/vub300.c
> @@ -259,7 +259,7 @@ static int firmware_rom_wait_states = 0x
>  static int firmware_rom_wait_states = 0x1C;
>  #endif
>  
> -module_param(firmware_rom_wait_states, bool, 0644);
> +module_param(firmware_rom_wait_states, int, 0644);
>  MODULE_PARM_DESC(firmware_rom_wait_states,
>  		 "ROM wait states byte=RRRIIEEE (Reserved Internal External)");
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


