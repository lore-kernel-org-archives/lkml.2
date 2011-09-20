Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab1ITFmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 01:42:24 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45456 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1ITFmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 01:42:22 -0400
Date: Tue, 20 Sep 2011 15:42:18 +1000
From: Stephen Rothwell <sfr@au1.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the regmap tree with the mfd tree
Message-Id: <20110920154218.27c270321f7b24d6b2a8d862@au1.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Today's linux-next merge of the regmap tree got a conflict in
drivers/mfd/wm831x-spi.c between commit 7ba771ee9c6f ("mfd: Support
software initiated shutdown of WM831x PMICs") from the mfd tree and
commit 5570c2f709bd ("mfd: Use device ID matching for WM831x SPI driver")
from the regmap tree.

I am not sure of the resolution here, so I just used the regmap tree
version (which drops the shutdown member of wm8311_spi_driver added in
the mfd version).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
