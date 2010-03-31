Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab0CaG1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:27:42 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:62994 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab0CaG1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UJWWCeSIyNfv2mk7wh8Ozm5VZ2z3zRObL+3oxv9xMhxl3EY83O96mbMfDuRGQlxNr5
         DDjcNLb1UCkIoRfX8Ov9SkSnW/wGDvP492mFR9eiz9glhAAcYMQUf/O3TfF9BTba3zoX
         oqXLK+Uv9+X/w+Rj+BcVGMCYLH/3JpXkDoCIQ=
MIME-Version: 1.0
In-Reply-To: <x2q7f9d1ffb1003302307nb8e91be0o55da59c3375f1720@mail.gmail.com>
References: <35697.192.168.10.89.1265898023.squirrel@dbdmail.itg.ti.com> 
	<004701caab40$68b576e0$544ff780@am.dhcp.ti.com> <x2q7f9d1ffb1003302307nb8e91be0o55da59c3375f1720@mail.gmail.com>
From: Vimal Singh <vimal.newwork@gmail.com>
Date: Wed, 31 Mar 2010 11:57:20 +0530
Message-ID: <v2yce9ab5791003302327hc67deb3akc7d18146534038f9@mail.gmail.com>
Subject: Re: [PATCH-V2] OMAP: Fix for bus width which improves SD card's 
	peformance.
To: kishore kadiyala <kishorek.kadiyala@gmail.com>
Cc: Madhusudhan <madhu.cr@ti.com>, tony@atomide.com, svenkatr@ti.com,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       jarkko.lavinen@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  drivers/mmc/host/omap_hsmmc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 83f0aff..8c97c22 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -2092,7 +2092,7 @@ static int __init omap_hsmmc_probe(struct
>                   MMC_CAP_WAIT_WHILE_BUSY;
>
>      if (mmc_slot(host).wires >= 8)
> -               mmc->caps |= MMC_CAP_8_BIT_DATA;
> +               mmc->caps |= (MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA);
>      else if (mmc_slot(host).wires >= 4)
>              mmc->caps |= MMC_CAP_4_BIT_DATA;
>
Your mailer has some issue, 'tabs' got replaced by 'spaces' in this
patch. Please fix it and repost.

Also take care off deleting below unrelated content.

-
Regards,
Vimal

>
> On Thu, Feb 11, 2010 at 11:04 PM, Madhusudhan <madhu.cr@ti.com> wrote:
>>
>>
>>> -----Original Message-----
>>> From: kishore kadiyala [mailto:kishore.kadiyala@ti.com]
>>> Sent: Thursday, February 11, 2010 8:20 AM
>>> To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org
>>> Cc: jarkko.lavinen@nokia.com; madhu.cr@ti.com
>>> Subject: [PATCH] OMAP: Fix for bus width which improves SD card's
>>> peformance.
