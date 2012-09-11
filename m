Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab2IKG65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:58:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35863 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2IKG6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:58:53 -0400
Date: Tue, 11 Sep 2012 08:58:19 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Vinod Koul <vinod.koul@intel.com>,
        djbw@fb.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/2] dma: tegra: make tegra_dma.chip_data a pointer to
 const data
Message-ID: <20120911065819.GF28643@pengutronix.de>
References: <20120829084911.GE28643@pengutronix.de>
 <1346230295-15898-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <504E2F95.6040808@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <504E2F95.6040808@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 12:21:09PM -0600, Stephen Warren wrote:
> On 08/29/2012 02:51 AM, Uwe Kleine-König wrote:
> > From: Laxman Dewangan <ldewangan@nvidia.com>
> > 
> > This prepares *of_device_id.data becoming const. Without this change
> > the following warning would occur:
> > 
> > 	drivers/dma/tegra20-apb-dma.c: In function 'tegra_dma_probe':
> > 	drivers/dma/tegra20-apb-dma.c:1210:9: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]
> > 
> > [ukl: split Laxman's patch to prevent warnings in the middle of the
> > series. Original patch was sent with msgid
> > 1346217447-19730-1-git-send-email-ldewangan@nvidia.com]
> > 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> > Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Uwe,
> 
> I don't see these patches in linux-next, so compilation is still broken.
> Can you please apply them? Thanks.
I have, but my new tree didn't make it into arm-soc. Arnd/Olof, can you
please refetch it?

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
