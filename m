Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1KDM5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:57:42 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5352 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1KDM5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:57:41 -0400
Date: Fri, 4 Nov 2011 13:57:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [GIT PULL] hwmon updates for Linux 3.2
Message-ID: <20111104135705.4254d734@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 3.2 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

This includes support for a new device (Winbond/Nuvoton W83627UHG) and
random other improvements and cleanups.

 Documentation/hwmon/w83627ehf |   28 +++---
 drivers/hwmon/Kconfig         |   20 +++-
 drivers/hwmon/ad7414.c        |    7 +-
 drivers/hwmon/ad7418.c        |   27 ++----
 drivers/hwmon/ads1015.c       |   21 +----
 drivers/hwmon/ads7828.c       |   12 +--
 drivers/hwmon/asb100.c        |   10 +-
 drivers/hwmon/ds1621.c        |   24 +----
 drivers/hwmon/ds620.c         |   42 ++------
 drivers/hwmon/gl518sm.c       |    4 +-
 drivers/hwmon/gl520sm.c       |    4 +-
 drivers/hwmon/ibmaem.c        |   60 +++++++-----
 drivers/hwmon/jc42.c          |   52 ++++------
 drivers/hwmon/lm73.c          |   30 +++++--
 drivers/hwmon/lm75.c          |    9 +-
 drivers/hwmon/lm77.c          |    4 +-
 drivers/hwmon/lm90.c          |  146 ++++++++++++++---------------
 drivers/hwmon/lm92.c          |   26 +++---
 drivers/hwmon/max16065.c      |    4 +-
 drivers/hwmon/sht21.c         |   26 +-----
 drivers/hwmon/smm665.c        |   15 +--
 drivers/hwmon/smsc47b397.c    |   13 ++-
 drivers/hwmon/tmp102.c        |   44 ++++-----
 drivers/hwmon/w83627ehf.c     |  210 +++++++++++++++++++++++++++++++---------
 drivers/hwmon/w83781d.c       |   10 +-
 25 files changed, 439 insertions(+), 409 deletions(-)

---------------

Dean Nelson (1):
      hwmon: Avoid building drivers for powerpc that read/write ISA addresses

Jean Delvare (11):
      hwmon: (lm73) Make detection less problematic
      hwmon: (ibmaem) Fix error paths
      hwmon: (ibmaem) Make instance initializations independent
      hwmon: (ibmaem) Avoid repeated memory allocations
      hwmon: (lm90) Fix warnings
      hwmon: (lm90) Make code more readable
      hwmon: (smsc47b397) Fix checkpatch errors
      hwmon: Use i2c_smbus_{read,write}_word_swapped
      hwmon: (w83627ehf) Properly report PECI and AMD-SI sensor types
      hwmon: (w83627ehf) Clean up probe function
      hwmon: (w83627ehf) Add support for the W83627UHG

Thanks,
-- 
Jean Delvare
