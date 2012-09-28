Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab2I1Lfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:35:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65203 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab2I1Lfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:35:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2] mfd: da9052-core:  Use regmap_irq_get_virq() and fix the probe
Date: Fri, 28 Sep 2012 11:35:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Fabio Estevam <festevam@gmail.com>, sameo@linux.intel.com, marex@denx.de,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com> <201209280642.05747.arnd@arndb.de> <20120928105212.GC30869@opensource.wolfsonmicro.com>
In-Reply-To: <20120928105212.GC30869@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209281135.16201.arnd@arndb.de>
X-Provags-ID: V02:K0:gDMPn/iNMorEXycECRcpIlTvQ7DGPJecK0cCT3A7cjS
 KptnHQkKf5+jWQlMcWcN1rvQL0nrS8O50uWxsVXxzXuj6X2esg
 COcN+KiauCF0tW7MLDh7Zoiri69zB9ASWnyNtrH9vrBA5t4b/e
 hAtfThfrlmT/PRHPFINChd17i4flUCfB+JiNgE4ihIyN522LJ0
 hio9B75xEUybUmia5if/n3Kx/kom+LzxBEFDkKBwvtHYM9zBdg
 ralRmYY1Gn77A7lRhS9OU0Klmv1tI9VVZ0YeXsuQ5xzXF+mEfn
 v6hUv3IQTHPs96qI2WaHPChUwD41bTh2FzjOLW82APqKL6JWwM
 5tBeXAurTdc+waOQydi8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2012, Mark Brown wrote:
> On Fri, Sep 28, 2012 at 06:42:05AM +0000, Arnd Bergmann wrote:
> > On Friday 28 September 2012, Fabio Estevam wrote:
> 
> > > I also plan to convert the other da9052 drivers to use regmap_irq_get_virq().
> 
> > Ok, I think they have to be submitted together though, because otherwise
> > the other drivers are more broken now.
> 
> Given that the drivers don't currently load I'm not sure it's worth the
> effort of arranging to get them all merged through one tree, probably
> easier to get as many fixes as possible merged as fast as possible.

Agreed. I didn't know the driver still had problems of this scale.

	Arnd
