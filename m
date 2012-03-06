Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031221Ab2CFVGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:06:42 -0500
Received: from csmtp2.one.com ([91.198.169.22]:13935 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031076Ab2CFVGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:06:41 -0500
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCHv2 0/3] Add support for bmp18x to bmp085
Date: Tue,  6 Mar 2012 22:08:01 +0100
Message-Id: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 2 of the patch-set that adds support for Bosch Sensortec's
bmp18x pressure sensors.

The patches have been restructured some to incremently expand the existing bmp085
driver. The last patch renames the bmp085 driver to bmp18x simply because the bmp18x
series obsoletes the old bmp085 chips.

--
Best regards,
 Eric

 http://www.unixphere.com

Eric Andersson (3):
  misc: clean up bmp085 driver
  misc: add support for bmp18x chips in bmp085 driver
  misc: rename bmp085 to bmp18x

 drivers/misc/Kconfig       |   38 +++-
 drivers/misc/Makefile      |    4 +-
 drivers/misc/bmp085-i2c.c  |  133 ++++++++++++
 drivers/misc/bmp085.c      |  483 -----------------------------------------
 drivers/misc/bmp18x-i2c.c  |  133 ++++++++++++
 drivers/misc/bmp18x-spi.c  |  139 ++++++++++++
 drivers/misc/bmp18x.c      |  510 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/bmp18x.h |   62 ++++++
 8 files changed, 1009 insertions(+), 493 deletions(-)
 create mode 100644 drivers/misc/bmp085-i2c.c
 delete mode 100644 drivers/misc/bmp085.c
 create mode 100644 drivers/misc/bmp18x-i2c.c
 create mode 100644 drivers/misc/bmp18x-spi.c
 create mode 100644 drivers/misc/bmp18x.c
 create mode 100644 include/linux/i2c/bmp18x.h

-- 
1.7.3.4

