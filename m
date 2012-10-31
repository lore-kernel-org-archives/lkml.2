Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab2JaDvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 23:51:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34742 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234Ab2JaDvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 23:51:47 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        "Porter, Matt" <mporter@ti.com>, "Dill, Russ" <russ.dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] da8xx: Fix revision check on the da8xx driver
Thread-Topic: [PATCH] da8xx: Fix revision check on the da8xx driver
Thread-Index: AQHNtsqfCgc9UO0H5UCB7Zm0ApPz9pfSxjAA
Date: Wed, 31 Oct 2012 03:51:35 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3E9E10D6@DBDE01.ent.ti.com>
References: <1351698984-4007-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1351698984-4007-1-git-send-email-panto@antoniou-consulting.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 21:26:24, Pantelis Antoniou wrote:
> The revision check fails for the beaglebone; Add new revision ID.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/video/da8xx-fb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
> index 80665f6..866d804 100644
> --- a/drivers/video/da8xx-fb.c
> +++ b/drivers/video/da8xx-fb.c
> @@ -1283,6 +1283,7 @@ static int __devinit fb_probe(struct platform_device *device)
>  		lcd_revision = LCD_VERSION_1;
>  		break;
>  	case 0x4F200800:
> +	case 0x4F201000:

Thanks for Correcting. This is the LCDC revision on am335x silicon in comparison
with to one read(0x4F200800) on emulator platform.

Acked-by: Manjunathappa, Prakash <prakash.pm@ti.com>

>  		lcd_revision = LCD_VERSION_2;
>  		break;
>  	default:
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

