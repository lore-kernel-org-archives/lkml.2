Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab0GIO3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:29:50 -0400
Received: from bamako.nerim.net ([62.4.17.28]:54153 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749Ab0GIO3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:29:49 -0400
Date: Fri, 9 Jul 2010 16:29:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 2.6.35
Message-ID: <20100709162944.7b4a9c02@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.35 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 drivers/hwmon/coretemp.c      |   32 ++++++++++++++++++++++++++++++--
 drivers/hwmon/it87.c          |   22 ++++++++++++++++++++++
 drivers/hwmon/k8temp.c        |   10 ++++++----
 drivers/i2c/busses/i2c-i801.c |    8 ++------
 4 files changed, 60 insertions(+), 12 deletions(-)

---------------

Andreas Herrmann (1):
      hwmon: (k8temp) Fix temperature reporting for ASB1 processor revisions

Jean Delvare (4):
      hwmon: (it87) Fix in7 on IT8720F
      hwmon: (coretemp) Skip duplicate CPU entries
      hwmon: (coretemp) Properly label the sensors
      hwmon: Fix autoloading of fschmd on recent Fujitsu machines

Thanks,
-- 
Jean Delvare
