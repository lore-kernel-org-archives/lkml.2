Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab0LaKX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:23:56 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33424 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab0LaKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:23:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cv8aMcZP2MqM7iJL3WhhvZNl8daggiE11y9SdMuhSRUImB1dfnC+ad06KnEsMrw2Bz
         UruvyFPfKMJ10t1g3cckVZX+4Ga5Z4UZpK2zddL1k2w5SVCa8SaPTY+ZlIti2jjx25gH
         btJCpge0yQ011/fGznq6+MYGBQasbuGPFgHBk=
Message-ID: <4D1DAF2D.5070604@gmail.com>
Date: Fri, 31 Dec 2010 08:23:41 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 11/15]drivers:media:video:cx18:cx23418.h Typo change diable
 to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <1293750484-1161-3-git-send-email-justinmattock@gmail.com> <1293750484-1161-4-git-send-email-justinmattock@gmail.com> <1293750484-1161-5-git-send-email-justinmattock@gmail.com> <1293750484-1161-6-git-send-email-justinmattock@gmail.com> <1293750484-1161-7-git-send-email-justinmattock@gmail.com> <1293750484-1161-8-git-send-email-justinmattock@gmail.com> <1293750484-1161-9-git-send-email-justinmattock@gmail.com> <1293750484-1161-10-git-send-email-justinmattock@gmail.com> <1293750484-1161-11-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1293750484-1161-11-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-12-2010 21:08, Justin P. Mattock escreveu:
> The below patch fixes a typo "diable" to "disable". Please let me know if this 
> is correct or not.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> ---
>  drivers/media/video/cx18/cx23418.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx23418.h b/drivers/media/video/cx18/cx23418.h
> index 2c00980..7e40035 100644
> --- a/drivers/media/video/cx18/cx23418.h
> +++ b/drivers/media/video/cx18/cx23418.h
> @@ -177,7 +177,7 @@
>     IN[0] - Task handle.
>     IN[1] - luma type: 0 = disable, 1 = 1D horizontal only, 2 = 1D vertical only,
>  		      3 = 2D H/V separable, 4 = 2D symmetric non-separable
> -   IN[2] - chroma type: 0 - diable, 1 = 1D horizontal
> +   IN[2] - chroma type: 0 - disable, 1 = 1D horizontal
>     ReturnCode - One of the ERR_CAPTURE_... */
>  #define CX18_CPU_SET_SPATIAL_FILTER_TYPE     	(CPU_CMD_MASK_CAPTURE | 0x000C)
>  

