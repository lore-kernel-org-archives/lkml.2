Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab0KOVE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:04:59 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:41475 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694Ab0KOVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:04:58 -0500
Date: Mon, 15 Nov 2010 22:04:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.37
Message-ID: <20101115220450.586f9a2c@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

The bulk of it are late fixes to the new w83795 driver.

 drivers/hwmon/amc6821.c |    2 +-
 drivers/hwmon/lm93.c    |    4 +-
 drivers/hwmon/lm95241.c |   19 +++-
 drivers/hwmon/max6650.c |    2 +-
 drivers/hwmon/w83795.c  |  207 +++++++++++++++++++++++++++++++++++++++--------
 5 files changed, 192 insertions(+), 42 deletions(-)

---------------

Hans J. Koch (1):
      hwmon: Change mail address of Hans J. Koch

Jean Delvare (8):
      hwmon: (lm95241) Check validity of input values
      hwmon: (w83795) Fix fan control mode attributes
      hwmon: (w83795) Expose fan control method
      hwmon: (w83795) List all usable temperature sources
      hwmon: (w83795) Print the actual temperature channels as sources
      hwmon: (w83795) Read the intrusion state properly
      hwmon: (w83795) Clear intrusion alarm immediately
      hwmon: (w83795) Check for BEEP pin availability

Thanks,
-- 
Jean Delvare
