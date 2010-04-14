Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0DNOrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:47:12 -0400
Received: from bamako.nerim.net ([62.4.17.28]:63385 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab0DNOrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:47:11 -0400
Date: Wed, 14 Apr 2010 16:47:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 2.6.34
Message-ID: <20100414164708.6bfd7521@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.34 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 MAINTAINERS              |    4 ++--
 drivers/hwmon/applesmc.c |   18 ++++++++++++++++++
 drivers/hwmon/it87.c     |   32 +++++++++++++++-----------------
 drivers/hwmon/sht15.c    |   13 +++++++++----
 4 files changed, 44 insertions(+), 23 deletions(-)

---------------

Henrik Rydberg (1):
      hwmon: (applesmc) Switch maintainers

Jean Delvare (4):
      hwmon: (sht15) Properly handle the case CONFIG_REGULATOR=n
      hwmon: (it87) Don't arbitrarily enable temperature channels
      hwmon: (it87) Properly handle wrong sensor type requests
      hwmon: (it87) Invalidate cache on temperature sensor change

Jerome Oufella (1):
      hwmon: (sht15) Fix sht15_calc_temp interpolation function

Justin P. Mattock (1):
      hwmon: (applesmc) Add iMac9,1 and MacBookPro2,2 support

Thanks,
-- 
Jean Delvare
