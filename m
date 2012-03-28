Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab2C1RjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:39:25 -0400
Received: from ftp.meprolight.com ([194.90.149.17]:53059 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758273Ab2C1RjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:39:23 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 28 Mar 2012 19:38:56 +0200
Subject: RE: [PATCH] mfd: mc13xxx: add I2C support fix building for v3.4
Thread-Topic: [PATCH] mfd: mc13xxx: add I2C support fix building for v3.4
Thread-Index: Ac0NALQjoYhxXy0VRUuMt9P6Sw3tagAA3moE
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD26@MEP-EXCH.meprolight.com>
References: <1332943273-22447-1-git-send-email-alexg@meprolight.com>
	<20120328144017.GV3232@opensource.wolfsonmicro.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD25@MEP-EXCH.meprolight.com>,<20120328163512.GB3232@opensource.wolfsonmicro.com>
In-Reply-To: <20120328163512.GB3232@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> You ask me about another solution?

> > I'm saying either I'm missing something or this needs to be fixed in the
> > patches that introduce the regmap usage.

You understood correctly, it took me time to understand :-)
No problem I can split this patch:

> > +     select REGMAP_I2C if I2C
> > +     select REGMAP_SPI if SPI_MASTER

It will go to  v4 mfd: mc13xxx-core: use regmap for register access, 

Only the second part will be in this patch

-	struct device_node *np = mc13xxx->dev.of_node;
+	struct device_node *np = mc13xxx->dev->of_node;

 








