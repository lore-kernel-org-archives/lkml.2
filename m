Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab2HCPgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:36:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59786 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2HCPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:36:33 -0400
From: =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
To: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        rob@landley.net
Cc: jeffrey.t.kirsher@intel.com, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, joe@perches.com,
        ralf@linux-mips.org, dirk.brandewie@gmail.com,
        jayachandranc@netlogicmicro.com, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>
Subject: [PATCH v2 0/2] I2C: SIS964: Bus driver 
Date: Fri,  3 Aug 2012 17:35:43 +0200
Message-Id: <1344008145-14579-1-git-send-email-amaury.decreme@gmail.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches are a I2C bus driver for the SIS964.


The SIS964 is nearly the same as SIS630 for the SMBUS :
	- Most of the SMBus registers (Status, Enable, Control,
	  Host Control, etc.) are at the same adresses + 0x60
	- The register count is 21 instead of 20

The SIS964 name is ambiguous as this chip isn't part of the SIS96X
family and behaves differently.

The datasheets have been used to develop the driver based on the
exsiting driver for I2C SIS630 . 


Content of the patches:
	- 1/2 The driver itself
	- 2/2 Documentation, Kconfig, Makefile, Maintainers


Changes:
	V2
	- Remove of the insertion on include/linux/pci_ids.h
	and no quirk needed
	- Cosmetics on the source code + patch split

Amaury Decrême (2):
  I2C: SIS964: Bus driver - Driver
  I2C: SIS964: Bus driver - other files

 Documentation/i2c/busses/i2c-sis964 |   36 +++
 MAINTAINERS                         |    7 +
 drivers/i2c/busses/Kconfig          |   12 +-
 drivers/i2c/busses/Makefile         |    1 +
 drivers/i2c/busses/i2c-sis964.c     |  578 +++++++++++++++++++++++++++++++++++
 5 files changed, 633 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/i2c/busses/i2c-sis964
 create mode 100644 drivers/i2c/busses/i2c-sis964.c

-- 
1.7.8.6

