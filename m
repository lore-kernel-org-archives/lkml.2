Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2CNGCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:02:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65367 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab2CNGB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:01:57 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 0/5] dt: add basic imx28 support
Date: Wed, 14 Mar 2012 07:01:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-1-amd64; KDE/4.7.4; x86_64; ; )
Cc: Dong Aisheng <b29396@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        vinod.koul@linux.intel.com, s.hauer@pengutronix.de,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rdunlap@xenotime.net, kernel@pengutronix.de, cjb@laptop.org,
        shawn.guo@freescale.com
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1331628428-24017-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203140701.07111.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dong Aisheng,

> This patch series adds basic imx28 dt support including fec, mmc and dma.
> 
> Tested on mx28evk.
> 
> TODO:
> Convert the remaining devices to support dt.
> mxs-auart, mxs-gpio, i2c, flexcan, saif, rtc, pwm, fb.
> 
> Dong Aisheng (5):
>   ARM: imx28: add basic dt support
>   mmc: mxs-mmc: add dt probe support
>   ARM: imx28evk: add mmc dt support
>   dma: mxs-dma: add dt probe support
>   ARM: mxs: add mxs dma dt support
> 
Can you keep me in Cc on new versions of these patches? Thanks!

Best regards,
Marek Vasut
