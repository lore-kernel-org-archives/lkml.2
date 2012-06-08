Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2FHWYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:24:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51399 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2FHWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:24:53 -0400
From: mathieu.poirier@linaro.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 0/6] drivers: randconfig patches for kernel 3.5
Date: Fri,  8 Jun 2012 16:24:34 -0600
Message-Id: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

These patches fix miscellaneous problems when working
with make randconfig.  They were discovered on kernel
3.1-rc4 and sent out during the 3.4 cycle but were not
ack'ed.  

Sending out again for completeness.

Arnd Bergmann (6):
  drivers/video: use correct __devexit_p annotation
  mg_disk: use readb/writeb instead of inb/outb
  video/ili9320: do not mark exported functions __devexit
  video/console: automatically select a font
  drivers/savagefb: use mdelay instead of udelay
  drivers/tosa: driver needs I2C and SPI to compile

 drivers/block/mg_disk.c                |   78 ++++++++++++++++----------------
 drivers/video/backlight/Kconfig        |    2 +-
 drivers/video/backlight/ili9320.c      |    2 +-
 drivers/video/broadsheetfb.c           |    2 +-
 drivers/video/console/Kconfig          |   14 ++++++
 drivers/video/mbx/mbxfb.c              |    2 +-
 drivers/video/savage/savagefb_driver.c |   10 ++--
 7 files changed, 62 insertions(+), 48 deletions(-)

-- 
1.7.5.4

