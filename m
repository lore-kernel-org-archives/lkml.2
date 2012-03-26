Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab2CZDxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 23:53:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1781 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2CZDxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 23:53:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 25 Mar 2012 20:53:20 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Mar 2012 09:23:06 +0530
Subject: RE: [PATCH v3] regulator: Add TPS65090 regulator driver
Thread-Topic: [PATCH v3] regulator: Add TPS65090 regulator driver
Thread-Index: Ac0IRUIsG2y4vKJcT5OCSVBVYC3/vgCvoXRw
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD312816F@BGMAIL02.nvidia.com>
References: <1332421449-15656-1-git-send-email-vbyravarasu@nvidia.com>
 <20120322160256.GK3091@opensource.wolfsonmicro.com>
In-Reply-To: <20120322160256.GK3091@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > TPS65090 PMIC from TI consists of 3 step down converters,
> > 2 always on LDOs and 7 current limited load switches. The
> > output voltages are ON/OFF controllable and are meant to
> > supply power to the components on target board.
> 
> Applied, but...
> 
> > +	rdev = regulator_register(&ri->desc, &pdev->dev,
> > +				&tps_pdata->regulator, ri, NULL);
> > +	if (IS_ERR_OR_NULL(rdev)) {
> 
> ...please submit an incremental patch changing this to plain IS_ERR(),
> regulator_register() only returns error pointers.  Note that no other
> regulator drivers do this check.
Thanks Mark, for applying this patch.
As Axel already provided a patch to fix this, Acked on his patch.
