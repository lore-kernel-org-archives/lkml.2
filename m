Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1AJVVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:21:55 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:17803 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab1AJVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:21:53 -0500
Date: Mon, 10 Jan 2011 22:21:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.38
Message-ID: <20110110222145.31c40d8e@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem updates for Linux 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

Not much this time around... Only the new generic I2C multiplexer using
the GPIO API is worth mentioning.

 Documentation/i2c/muxes/gpio-i2cmux |   65 ++++++++++++
 MAINTAINERS                         |    8 ++
 drivers/i2c/algos/i2c-algo-bit.c    |   31 +++---
 drivers/i2c/busses/i2c-i801.c       |    1 +
 drivers/i2c/busses/i2c-nforce2.c    |    2 +-
 drivers/i2c/i2c-core.c              |   29 +++---
 drivers/i2c/muxes/Kconfig           |   12 +++
 drivers/i2c/muxes/Makefile          |    1 +
 drivers/i2c/muxes/gpio-i2cmux.c     |  184 +++++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-ds1307.c            |   12 +-
 include/linux/gpio-i2cmux.h         |   38 +++++++
 include/linux/i2c.h                 |   27 +++---
 12 files changed, 362 insertions(+), 48 deletions(-)
 create mode 100644 Documentation/i2c/muxes/gpio-i2cmux
 create mode 100644 drivers/i2c/muxes/gpio-i2cmux.c
 create mode 100644 include/linux/gpio-i2cmux.h

---------------

Ben Hutchings (1):
      i2c-i801: Include <linux/slab.h>

Jean Delvare (3):
      i2c-algo-bit: Refactor adapter registration
      i2c-algo-bit: Complain about masters which can't read SCL
      i2c: Constify i2c_client where possible

Joe Perches (1):
      i2c-nforce2: Remove unnecessary cast of pci_get_drvdata

Peter Korsgaard (1):
      i2c: Add generic I2C multiplexer using GPIO API

Thanks,
-- 
Jean Delvare
