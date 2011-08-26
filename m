Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1HZM4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:56:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33822 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1HZM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:56:43 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86,mrst: Add mapping for bma023
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 13:51:47 +0100
Message-ID: <20110826125131.5316.18229.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Douglas <william.douglas@intel.com>

There is now an upstream bma023 driver so instead of submitting ours we
use that one. The defaults are just fine so it's a simple mapping entry.

(Thanks go to Erik Andersson for incorporating the changes we needed into his
 version)

Signed-off-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/platform/mrst/mrst.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index cb6aa34..38dc8a8 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -498,6 +498,7 @@ static void __init *no_platform_data(void *info)
 }
 
 static const struct devs_id __initconst device_ids[] = {
+	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data},
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
 	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},

