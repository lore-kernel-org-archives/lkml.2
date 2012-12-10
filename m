Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2LJDXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 22:23:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55033 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab2LJDXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 22:23:00 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] regulator: lp8788-buck: Remove val array in
 lp8788_init_dvs
Thread-Topic: [PATCH 1/2] regulator: lp8788-buck: Remove val array in
 lp8788_init_dvs
Thread-Index: AQHN1Fx7h6YX3SDIO0e/AJrjM0LiqZgRUXtg//+CcACAAI5ZMA==
Date: Mon, 10 Dec 2012 03:22:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0579D@DQHE02.ent.ti.com>
References: <1354872181.15243.1.camel@phoenix>
	<A874F61F95741C4A9BA573A70FE3998F69E0574C@DQHE02.ent.ti.com>
 <CAFRkauAFZ-G=7R4LbBLuJaCwwgc6i+_9tNm8ozKRw7G1w07j3A@mail.gmail.com>
In-Reply-To: <CAFRkauAFZ-G=7R4LbBLuJaCwwgc6i+_9tNm8ozKRw7G1w07j3A@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, what you want is to clear mask[id] bits.
> Setting 0 for the data argument here is clear.

I would say it's not clearing bit but the DVS control configuration.
If the bit is 0, external pin is used for the DVS.
If it is 1, then DVS is controlled by other register settings.
Therefore, it's a kind of default configuration rather than clearing bits.

> But if you prefer to keep it as is, it's ok.
Thanks for your understanding.

Best Regards,
Milo


