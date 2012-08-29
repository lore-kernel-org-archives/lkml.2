Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab2H2ItZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:49:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40393 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2H2ItY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:49:24 -0400
Date: Wed, 29 Aug 2012 10:49:11 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: vinod.koul@intel.com, djbw@fb.com, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH RESEND] dma: tegra: add const to of_device_id.data's
 structure
Message-ID: <20120829084911.GE28643@pengutronix.de>
References: <1346217447-19730-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1346217447-19730-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 29, 2012 at 10:47:27AM +0530, Laxman Dewangan wrote:
> The member "data" of structure of_device_id is changed to const
> pointer. Hence initializing this with const type data.
> This will fix the compilation warning like
> drivers/dma/tegra20-apb-dma.c:1217:9: warning: assignment discards 'const' qualifier from
> pointer target type [enabled by default]
> 
> This warning came after the change
> ---------
> commit 98d7bbb9929bcc14e11ac8a55245a4f2dc174e17
> Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>     of: add const to struct *of_device_id.data
> ---------
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
I took the patch into my series now and split it in two to prevent
warnings in the middle of the series. I assumed the two acks for both
patches and send them in a moment in reply to this mail.

You can find the updated series

	git://git.pengutronix.de/git/ukl/linux.git ofdeviceiddata

Arnd or Olof, can you please update the corresponding branch arm-soc
from there?

Best regards and thanks
Uwe
