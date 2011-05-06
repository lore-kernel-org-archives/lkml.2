Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab1EFEPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 00:15:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27552 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1EFEPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 00:15:32 -0400
X-AuditID: cbfee61a-b7c84ae000006ee6-59-4dc375e21ed2
Date: Fri, 06 May 2011 13:15:27 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] leds: drop leds-h1940 driver
In-reply-to: <1303912597-32653-1-git-send-email-anarsoul@gmail.com>
To: "'Vasily Khoruzhick'" <anarsoul@gmail.com>, linux-kernel@vger.kernel.org,
        "'Arnaud Patard (Rtp)'" <arnaud.patard@rtp-net.org>,
        linux-arm-kernel@lists.infradead.org,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: rpurdie@rpsys.net
Message-id: <00f701cc0ba4$3cb4b680$b61e2380$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcwE45PCSwu7GiP0TqCTXTQWDnkykAGwAS6Q
References: <1303912597-32653-1-git-send-email-anarsoul@gmail.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Khoruzhick wrote:
> 
> H1940 machine now uses leds-gpio and leds-h1940 has no users anymore. So
> drop it.
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> ---
>  drivers/leds/Kconfig      |    7 --
>  drivers/leds/Makefile     |    1 -
>  drivers/leds/leds-h1940.c |  170
-------------------------------------------
> --
>  3 files changed, 0 insertions(+), 178 deletions(-)
>  delete mode 100644 drivers/leds/leds-h1940.c
> 
Hi Vasily,

Hmm, regarding maintainer who is Richard Purdie(LED) in this case should be
added in Cc. (Cc'ed him)

And I think need following with this patch.

--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -389,7 +389,6 @@ CONFIG_MMC_SPI=m
 CONFIG_MMC_S3C=y
 CONFIG_LEDS_CLASS=m
 CONFIG_LEDS_S3C24XX=m
-CONFIG_LEDS_H1940=m
 CONFIG_LEDS_PCA9532=m
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_PCA955X=m


Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

