Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1E2TQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:16:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab1E2TQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:16:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 2/2] ARM: mxs: use gpio-mxs driver by adding platform device
Date: Sun, 29 May 2011 21:16:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
References: <1306595374-25178-1-git-send-email-shawn.guo@linaro.org> <1306595374-25178-3-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1306595374-25178-3-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105292116.33862.arnd@arndb.de>
X-Provags-ID: V02:K0:WYopVWbbv0G/VPqlLjhK1Ii4X0wu5eaFtx/n2iq+u24
 aSiyN+ynGt1eGkAbA30JJYuG8V7E/Z/Bn1eGrMvsmrggJn4wHv
 QZT8RAuDMKyBTwHA6rOX1TXkLgmbscP5WwHx8kuQCKfWyyXCdN
 ByXKa4WJPu2eJ/p0LUe3Ac0GXUzxnz/LonoTOmxKnwItwqlz3D
 GILa+ZvFicAjk67NAGsyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 May 2011 17:09:34 Shawn Guo wrote:
> It replaces mach-mxs/gpio with gpio-mxs driver by adding platform
> device for drivers/gpio/gpio-mxs, and then remove the mach-mxs/gpio
> driver.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
