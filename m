Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2I1GmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:42:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55662 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2I1GmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:42:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2] mfd: da9052-core:  Use regmap_irq_get_virq() and fix the probe
Date: Fri, 28 Sep 2012 06:42:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com, marex@denx.de,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1348797458-2562-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209280642.05747.arnd@arndb.de>
X-Provags-ID: V02:K0:lkn40kLu0QCR9+Y4T6+B3sZhkIZskGg09VWm1Zw2BCT
 qbke4WTekUZwMK1gS+5AcgrWVcWzUSlA6/RtrCmUMjgjGEgGip
 XmmImUoZ4JZFMyjFI/MiKb561zPlxuAv4sPmyAp5i67jpS7/0R
 RCXd5R0+04y4EjI0ogi9FWads2nzqerfsE1J0EbtTiEmfx3Tit
 QB74SjJXKlU2JlWb2D1VyWFCmpMrIE/mbH82cOnWcqY9Oplcb2
 fPDZRn3ZHey/lonZj4sAB5b9ooAZhRrbrT94IBAaDvb+Uixkfc
 AxBp4+unZ0eq33Zjk1J+7XNzULrqM91bFouVBJeZwbfq2iq40x
 KX1ufOpCUwfYZgiq2DAI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2012, Fabio Estevam wrote:
> ---
> Changes since v2:
> - Use regmap_irq_get_virq() instead of relying on irq_base

This looks good.

> I also plan to convert the other da9052 drivers to use regmap_irq_get_virq().

Ok, I think they have to be submitted together though, because otherwise
the other drivers are more broken now.

	Arnd 
