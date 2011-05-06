Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1EFIDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:03:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53561 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1EFIDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=GjUUb0ua2SOZ3M+6BVMDzsn1R9YVt0Dufuellio4Q9pkADfP3NJRKn62Deyka8+7oi
         TuF86f2p7z0UDIu807Z7GF6vS6/8xNpHSDcVcTSv82/ssezdHACmedWuA41FKfP/22dR
         0USMzxLHvUWGe3PK+UE3/DViMwcjAz/3RHyMM=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] leds: drop leds-h1940 driver
Date: Fri, 6 May 2011 11:01:34 +0300
User-Agent: KMail/1.13.6 (Linux/2.6.38-gentoo-anarsoul; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
        "'Arnaud Patard (Rtp)'" <arnaud.patard@rtp-net.org>,
        linux-arm-kernel@lists.infradead.org,
        "'Ben Dooks'" <ben-linux@fluff.org>, rpurdie@rpsys.net
References: <1303912597-32653-1-git-send-email-anarsoul@gmail.com> <00f701cc0ba4$3cb4b680$b61e2380$%kim@samsung.com>
In-Reply-To: <00f701cc0ba4$3cb4b680$b61e2380$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105061101.34589.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 May 2011 07:15:27 Kukjin Kim wrote:
> Hi Vasily,

Hi
 
> Hmm, regarding maintainer who is Richard Purdie(LED) in this case should be
> added in Cc. (Cc'ed him)

Sorry, forgot to add him to CC :(

> And I think need following with this patch.
> 
> --- a/arch/arm/configs/s3c2410_defconfig
> +++ b/arch/arm/configs/s3c2410_defconfig
> @@ -389,7 +389,6 @@ CONFIG_MMC_SPI=m
>  CONFIG_MMC_S3C=y
>  CONFIG_LEDS_CLASS=m
>  CONFIG_LEDS_S3C24XX=m
> -CONFIG_LEDS_H1940=m
>  CONFIG_LEDS_PCA9532=m
>  CONFIG_LEDS_GPIO=m
>  CONFIG_LEDS_PCA955X=m

Sure. Can you commit this change to your tree, or should I resend patch with 
this change?

Regards
Vasily
