Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab1GYUya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:54:30 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25696 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1GYUy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:54:28 -0400
Date: Mon, 25 Jul 2011 21:51:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon updates for Linux 3.1
Message-ID: <20110725215116.161aed47@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 3.1 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

We have support for one new device (SMSC SCH5636), and minor
improvements and cleanups to a few drivers.

 Documentation/hwmon/it87       |    3 +-
 Documentation/hwmon/lm78       |    3 +-
 Documentation/hwmon/sch5636    |   31 +++
 MAINTAINERS                    |    7 +
 drivers/hwmon/Kconfig          |   21 ++
 drivers/hwmon/Makefile         |    2 +
 drivers/hwmon/hwmon-vid.c      |   42 +++-
 drivers/hwmon/it87.c           |   29 +++
 drivers/hwmon/lm78.c           |  305 +++++++++++++----------
 drivers/hwmon/max1111.c        |   27 +--
 drivers/hwmon/sch5627.c        |  334 ++-----------------------
 drivers/hwmon/sch5636.c        |  539 ++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/sch56xx-common.c |  340 +++++++++++++++++++++++++
 drivers/hwmon/sch56xx-common.h |   24 ++
 drivers/hwmon/sht15.c          |    2 +-
 drivers/hwmon/via-cputemp.c    |   44 +++-
 16 files changed, 1285 insertions(+), 468 deletions(-)
 create mode 100644 Documentation/hwmon/sch5636
 create mode 100644 drivers/hwmon/sch5636.c
 create mode 100644 drivers/hwmon/sch56xx-common.c
 create mode 100644 drivers/hwmon/sch56xx-common.h

---------------

Hans de Goede (2):
      hwmon: (sch5627) Factor out some code shared with sch5636 driver
      hwmon: New driver sch5636

Jean Delvare (7):
      hwmon-vid: Add support for VIA family 6 model D CPU
      hwmon: (via-cputemp) Add VID reporting support
      hwmon: (it87) Add chassis intrusion detection support
      hwmon: (max1111) Avoid extra memory allocations
      hwmon: (lm78) Avoid forward declarations
      hwmon: (lm78) Make ISA interface depend on CONFIG_ISA
      hwmon: (lm78) Become the maintainer

Vivien Didelot (1):
      hwmon: (sht15) Correct a comment mistake

Thanks,
-- 
Jean Delvare
