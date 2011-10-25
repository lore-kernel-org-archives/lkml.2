Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1JYH0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:26:46 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:44020
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072Ab1JYH0o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:26:44 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz9371K542M1432Nzz1202hzz8275bh8275dhz32i2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@conan.davemloft.net>,
        Mike Frysinger <vapier@gentoo.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Date: Tue, 25 Oct 2011 03:26:50 -0400
Subject: RE: [RFC PATCH 08/17] drivers/net/bfin_mac: Don't unnecessarily
 reset the PHY
Thread-Topic: [RFC PATCH 08/17] drivers/net/bfin_mac: Don't unnecessarily
 reset the PHY
Thread-Index: AcyPa7e9JWc0lyuoStukRE6UNMVOEADe6Umw
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16D3BA945D1@NWD2CMBX1.ad.analog.com>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <1319144425-15547-9-git-send-email-Kyle.D.Moffett@boeing.com>
In-Reply-To: <1319144425-15547-9-git-send-email-Kyle.D.Moffett@boeing.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang <sonic.zhang@analog.com>


Sonic

>-----Original Message-----
>From: Kyle Moffett [mailto:Kyle.D.Moffett@boeing.com]
>Sent: Friday, October 21, 2011 5:00 AM
>To: linux-kernel@vger.kernel.org; netdev@vger.kernel.org
>Cc: Kyle Moffett; David S. Miller; Mike Frysinger; Zhang,
>Sonic; Tobias Klauser; uclinux-dist-devel@blackfin.uclinux.org
>Subject: [RFC PATCH 08/17] drivers/net/bfin_mac: Don't
>unnecessarily reset the PHY
>
>The PHY is already reset during driver probing, and this
>manual reset afterwards will wipe out board-specific PHY
>fixups and driver-specific
>phy->drv->config_init() register tweaks.
>
>Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
>---
> drivers/net/bfin_mac.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
>index 6c019e1..1427ec3 100644
>--- a/drivers/net/bfin_mac.c
>+++ b/drivers/net/bfin_mac.c
>@@ -1402,7 +1402,6 @@ static int bfin_mac_open(struct net_device *dev)
>               return ret;
>
>       phy_start(lp->phydev);
>-      phy_write(lp->phydev, MII_BMCR, BMCR_RESET);
>       setup_system_regs(dev);
>       setup_mac_addr(dev->dev_addr);
>
>--
>1.7.2.5
>
>
>

