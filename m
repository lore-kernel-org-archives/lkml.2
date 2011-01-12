Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab1ALVJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 16:09:16 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:13659 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab1ALVJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:09:14 -0500
Date: Wed, 12 Jan 2011 22:08:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon updates for 2.6.38
Message-ID: <20110112220855.0b98a80e@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 2.6.38 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

Small cleanups in various drivers, with support for one new device
(SMSC EMC1423) and improved support for another (SMSC SCH5127), and
standardization of the intrusion detection interface.

 Documentation/feature-removal-schedule.txt |   10 ++
 Documentation/hwmon/adm9240                |    2 +-
 Documentation/hwmon/ads7828                |    2 +-
 Documentation/hwmon/dme1737                |   12 +-
 Documentation/hwmon/w83627hf               |   22 ++++
 Documentation/hwmon/w83793                 |    2 +-
 drivers/hwmon/Kconfig                      |    4 +-
 drivers/hwmon/adm9240.c                    |   32 +++++-
 drivers/hwmon/ads7828.c                    |    4 +-
 drivers/hwmon/dme1737.c                    |  189 ++++++++++++++++++---------
 drivers/hwmon/emc1403.c                    |   16 ++-
 drivers/hwmon/fschmd.c                     |    5 +-
 drivers/hwmon/it87.c                       |   30 ++---
 drivers/hwmon/lm78.c                       |   14 +-
 drivers/hwmon/pc87360.c                    |   53 ++++-----
 drivers/hwmon/pc87427.c                    |   26 ++--
 drivers/hwmon/via686a.c                    |   14 ++-
 drivers/hwmon/w83781d.c                    |   29 ++---
 drivers/hwmon/w83792d.c                    |   44 ++++++-
 drivers/hwmon/w83793.c                     |   38 +++++-
 drivers/hwmon/w83795.c                     |    4 +-
 21 files changed, 370 insertions(+), 182 deletions(-)

---------------

Jean Delvare (9):
      hwmon: (w83795) Silent false warning from gcc
      hwmon: (via686a) Initialize fan_div values
      hwmon: (adm9240) Implement the standard intrusion detection interface
      hwmon: (w83792d) Implement the standard intrusion detection interface
      hwmon: (w83793) Implement the standard intrusion detection interface
      hwmon: Schedule the removal of the old intrusion detection interfaces
      hwmon: (fschmd) Drop useless mutex
      hwmon: (w83793) Drop useless mutex
      hwmon: (w83627hf) Document W83627THF voltage pin mapping

Jekyll Lai (1):
      hwmon: (emc1403) Add EMC1423 support

Joe Perches (5):
      hwmon: (it87) Use pr_fmt and pr_<level>
      hwmon: (lm78) Use pr_fmt and pr_<level>
      hwmon: (pc87360) Use pr_fmt and pr_<level>
      hwmon: (pc87427) Use pr_fmt and pr_<level>
      hwmon: (w83781d) Use pr_fmt and pr_<level>

Juerg Haefliger (2):
      hwmon: (dme1737) Add support for in7 for SCH5127
      hwmon: (dme1737) Minor cleanups

Steven Hardy (1):
      hwmon: (ads7828) Update email contact details

Thanks,
-- 
Jean Delvare
