Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2H0ObA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 10:31:00 -0400
Received: from portal.weinmann.de ([62.8.140.122]:65148 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2H0OaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 10:30:09 -0400
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'ludovic.desroches'" <ludovic.desroches@atmel.com>,
        "''Wolfram Sang' (w.sang@pengutronix.de)'" <w.sang@pengutronix.de>
CC: "'Yanes Martinez Adrian'" <adrian.yanes@aalto.fi>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'balbi@ti.com'" <balbi@ti.com>,
        "'h.feurstein@gmail.com'" <h.feurstein@gmail.com>,
        "'rmallon@gmail.com'" <rmallon@gmail.com>,
        "'carsten.behling@garz-fricke.com'" <carsten.behling@garz-fricke.com>
Date: Mon, 27 Aug 2012 16:29:47 +0200
Subject: RE: [PATCH v11 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH v11 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: Ac2EXE2iVS0cvLIqSyi83fUJj0OlRAAAoEQA
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D090EC3D747@wm021.weinmann.com>
References: <cover.1345618760.git.n.voss@weinmann.de>
 <4f3dcfbf1e8eab3e251ab3558e9e1e9123643928.1345618760.git.n.voss@weinmann.de>,<503B4919.6080306@atmel.com>
 <BC0F374A1C27184AB96177CDFEC2F54225ECC330@EXMDB06.org.aalto.fi>,<503B623C.4030304@atmel.com>
 <BC0F374A1C27184AB96177CDFEC2F54225ECD36E@EXMDB06.org.aalto.fi>
 <EF2E73589CA71846A15D0B2CDF79505D090EC3D6F6@wm021.weinmann.com>
 <503B7D6E.7090906@atmel.com>
In-Reply-To: <503B7D6E.7090906@atmel.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalId: qfq7RETnx0020039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ludovic.desroches wrote on Monday, August 27, 2012 4:00 PM :
> For the moment, I don't have the necessary knowledge about the TWI
> controller to take a decision. I would say it can be done in an other
> patch in order to have your driver included in the mainline quickly
> since it doesn't introduce a breakage.

That would be the most pragmatic approach.
Wolfram, is the anything left to do from my side?

Regards,
Niko
 
