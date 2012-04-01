Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab2DAHho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 03:37:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41835 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2DAHhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 03:37:41 -0400
From: Marc Reilly <marc@cpdesign.com.au>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, oskar@scara.com,
        linux-kernel@vger.kernel.org, alexg@meprolight.com
Subject: mc13xxx: add I2C support, V5
Date: Sun,  1 Apr 2012 16:41:35 +1000
Message-Id: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series (against mfd-2.6/for-next) changes the mc13xxx driver to use 
regmap and adds I2C support.
It has a compile dependency on regmap/for-next, as the spi driver uses the
recently added pad_bits config field.

Patch 2/4 has:
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Patch 4/4 has:
Signed-off-by: Oskar Schirmer <oskar@scara.com>

Changes since:
V4:
- Fix compile error when CONFIG_OF enabled
- Select REGMAP_I2C and REGMAP_SPI for appropriate drivers.

V3:
- spi driver uses padded register format (reads should actually work now!)
- mc13873 removed from I2C driver
- fix memory leak on probe error

Cheers,
Marc


