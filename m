Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2DIUPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:15:30 -0400
Received: from csmtp3.one.com ([91.198.169.23]:58542 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246Ab2DIUP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:15:28 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com, broonie@opensource.wolfsonmicro.com,
        christoph.mair@gmail.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCHv5 0/3] bmp085: add support for bmp18x chip
Date: Mon,  9 Apr 2012 22:16:14 +0200
Message-Id: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 5 of the patch-set that adds support for the latest pressure
sensors from Bosch Sensortec.

Changes from last version:
- Added "bosch" to vendor-prefixes.txt

--
Best regards,
 Eric

   http://www.unixphere.com

Eric Andersson (3):
  misc: clean up bmp085 driver
  misc: bmp085: add device tree properties
  misc: add support for bmp18x chips to the bmp085 driver

 Documentation/devicetree/bindings/misc/bmp085.txt |   20 ++
 drivers/misc/Kconfig                              |   26 ++-
 drivers/misc/Makefile                             |    2 +
 drivers/misc/bmp085-i2c.c                         |   91 ++++++
 drivers/misc/bmp085-spi.c                         |   91 ++++++
 drivers/misc/bmp085.c                             |  356 +++++++++++----------
 drivers/misc/bmp085.h                             |   33 ++
 7 files changed, 440 insertions(+), 179 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/bmp085.txt
 create mode 100644 drivers/misc/bmp085-i2c.c
 create mode 100644 drivers/misc/bmp085-spi.c
 create mode 100644 drivers/misc/bmp085.h

-- 
1.7.3.4

