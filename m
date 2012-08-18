Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2HRGrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 02:47:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64053 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HRGr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 02:47:28 -0400
Message-ID: <1345272439.7986.2.camel@phoenix>
Subject: regulator: max8907: build error when CONFIG_OF is not set
From: Axel Lin <axel.lin@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Sat, 18 Aug 2012 14:47:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I got below build error when CONFIG_OF is not set:

  CC [M]  drivers/regulator/max8907-regulator.o
drivers/regulator/max8907-regulator.c: In function 'max8907_regulator_probe':
drivers/regulator/max8907-regulator.c:297:12: error: 'max8907_matches' undeclared (first use in this function)
drivers/regulator/max8907-regulator.c:297:12: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [drivers/regulator/max8907-regulator.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Regards,
Axel

