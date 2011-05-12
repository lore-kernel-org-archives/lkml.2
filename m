Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab1ELBer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:34:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24050 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab1ELBeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:34:46 -0400
X-AuditID: cbfee61b-b7bb4ae000002c54-d4-4dcb39342a87
Date: Thu, 12 May 2011 10:34:40 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] leds: drop leds-h1940 driver
In-reply-to: <201105061101.34589.anarsoul@gmail.com>
To: "'Vasily Khoruzhick'" <anarsoul@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "'Arnaud Patard (Rtp)'" <arnaud.patard@rtp-net.org>,
        linux-arm-kernel@lists.infradead.org,
        "'Ben Dooks'" <ben-linux@fluff.org>, rpurdie@rpsys.net
Message-id: <03c101cc1044$c53b7350$4fb259f0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcwLxCF5uVZr/Qi0Tu+NNOD2wJlWLwEgDWtQ
References: <1303912597-32653-1-git-send-email-anarsoul@gmail.com>
 <00f701cc0ba4$3cb4b680$b61e2380$%kim@samsung.com>
 <201105061101.34589.anarsoul@gmail.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Khoruzhick wrote:
> 
> On Friday 06 May 2011 07:15:27 Kukjin Kim wrote:
> > Hi Vasily,
> 
> Hi
> 
Hi :)

> > Hmm, regarding maintainer who is Richard Purdie(LED) in this case should
be
> > added in Cc. (Cc'ed him)
> 
> Sorry, forgot to add him to CC :(
> 
No problem :)

> > And I think need following with this patch.
> >
> > --- a/arch/arm/configs/s3c2410_defconfig
> > +++ b/arch/arm/configs/s3c2410_defconfig
> > @@ -389,7 +389,6 @@ CONFIG_MMC_SPI=m
> >  CONFIG_MMC_S3C=y
> >  CONFIG_LEDS_CLASS=m
> >  CONFIG_LEDS_S3C24XX=m
> > -CONFIG_LEDS_H1940=m
> >  CONFIG_LEDS_PCA9532=m
> >  CONFIG_LEDS_GPIO=m
> >  CONFIG_LEDS_PCA955X=m
> 
> Sure. Can you commit this change to your tree, or should I resend patch
with
> this change?
> 
Ok, I will do it after merging your patch into Richard's tree.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

