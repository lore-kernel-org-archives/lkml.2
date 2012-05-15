Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966886Ab2EOVDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:03:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42678 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966675Ab2EOVDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:03:08 -0400
From: mathieu.poirier@linaro.org
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH 0/5] drivers/video: randconfig patches for kernel 3.4.patch
Date: Tue, 15 May 2012 15:02:56 -0600
Message-Id: <1337115781-27979-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

These patches fix miscellaneous problems when working
with make randconfig.  They were discovered on kernel
3.1-rc4 and have been reformatted for 3.4.

Arnd Bergmann (5):
  drivers/video: use correct __devexit_p annotation
  video/ili9320: do not mark exported functions __devexit
  video/console: automatically select a font
  drivers/savagefb: use mdelay instead of udelay
  drivers/tosa: driver needs I2C and SPI to compile

 drivers/video/backlight/Kconfig        |    2 +-
 drivers/video/backlight/ili9320.c      |    2 +-
 drivers/video/broadsheetfb.c           |    2 +-
 drivers/video/console/Kconfig          |   14 ++++++++++++++
 drivers/video/mbx/mbxfb.c              |    2 +-
 drivers/video/savage/savagefb_driver.c |   10 +++++-----
 6 files changed, 23 insertions(+), 9 deletions(-)

-- 
1.7.5.4

