Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab2FUIN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:13:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40378 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab2FUINW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:13:22 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>, Stephen Warren <swarren@wwwdotorg.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: RE: linux-next: build failure after merge of the regulator tree
Thread-Topic: linux-next: build failure after merge of the regulator tree
Thread-Index: AQHNT13W1qE+8LrsRUWr/x172e/ldZcEaidw
Date: Thu, 21 Jun 2012 08:13:15 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FC074@DQHE02.ent.ti.com>
References: <20120621132738.6e797593acc58b3e30902f69@canb.auug.org.au>
In-Reply-To: <20120621132738.6e797593acc58b3e30902f69@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Caused by commit 809d310c7e69 ("regulator: lp872x: Don't allow modular
> build") but that was done to fix a different build problem.

Sorry for this conflict.

Build config of lp872x driver has been changed as tristate.
And related undefined symbol error has been fixed.
(don't use devm_gpio_request_one() at this moment because it can not be exported.)

Please check patches below.

[PATCH 1/3] regulator: enable module build config for lp872x
[PATCH 2/3] regulator: replace devm_gpio_request_one() for loaded module

Thanks & BR
Milo -
