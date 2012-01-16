Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2APWBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:01:05 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:30912 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab2APWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:01:03 -0500
Date: Mon, 16 Jan 2012 23:00:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon updates for Linux 3.3
Message-ID: <20120116230051.5a246e6b@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 3.3 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

We have support for the ITE IT8728F, and an improved lm63 driver.

 Documentation/hwmon/it87            |   13 +-
 Documentation/hwmon/lm63            |   21 +-
 Documentation/hwmon/sysfs-interface |    2 +-
 drivers/hwmon/Kconfig               |    8 +-
 drivers/hwmon/adm1031.c             |  153 ++++++---
 drivers/hwmon/coretemp.c            |   26 +-
 drivers/hwmon/it87.c                |   61 +++-
 drivers/hwmon/lm63.c                |  592 +++++++++++++++++++++++++++++++----
 drivers/hwmon/lm90.c                |    2 +-
 drivers/hwmon/max1111.c             |   15 +-
 10 files changed, 735 insertions(+), 158 deletions(-)

---------------

Eric Miao (1):
      hwmon: (max1111) Change sysfs interface to in[0-3]_input in millivolts

Guenter Roeck (10):
      hwmon: (lm63) Fix checkpatch errors
      hwmon: (lm63) Add support for external temperature offset register
      hwmon: (lm63) Add support for LM96163
      hwmon: (lm63) Add support for unsigned upper temperature limits
      hwmon: (lm63) Add support for writing the external critical temperature
      hwmon: (lm63) Add support for update_interval sysfs attribute
      hwmon: (lm63) Add sensor type attribute for external sensor on LM96163
      hwmon: (lm90) Add range check to set_update_interval
      hwmon: (adm1031) Fix coding style issues
      hwmon: (sysfs-interface) Update tempX_type attribute to be more generic

Jean Delvare (6):
      hwmon: (lm63) LM64 has a dedicated pin for tachometer
      hwmon: (lm63) Fix incorrect comment about I2C address
      hwmon: (lm63) Expose automatic fan speed control lookup table
      hwmon: (lm63) Support extended lookup table of LM96163
      hwmon: (coretemp) Add missing section annotations
      hwmon: (it87) Add IT8728F support

Thanks,
-- 
Jean Delvare
