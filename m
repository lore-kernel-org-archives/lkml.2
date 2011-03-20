Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1CTOmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 10:42:00 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3677 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1CTOl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 10:41:58 -0400
Date: Sun, 20 Mar 2011 15:41:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.39
Message-ID: <20110320154143.2f0d6e4d@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem updates for Linux 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

Mostly core clean-ups this time.

 Documentation/feature-removal-schedule.txt |   19 ++++-----
 Documentation/i2c/busses/i2c-i801          |    3 +-
 Documentation/i2c/instantiating-devices    |    2 +-
 Documentation/i2c/upgrading-clients        |   18 ++++----
 Documentation/video4linux/Zoran            |    2 +-
 drivers/i2c/Makefile                       |    1 +
 drivers/i2c/busses/Kconfig                 |    3 +-
 drivers/i2c/busses/i2c-i801.c              |    4 +-
 drivers/i2c/i2c-boardinfo.c                |    2 +-
 drivers/i2c/i2c-core.c                     |   28 +++++++++----
 drivers/i2c/i2c-dev.c                      |   60 ++++++++++++++++++----------
 include/linux/i2c-id.h                     |   37 -----------------
 include/linux/i2c.h                        |   18 ++++----
 13 files changed, 97 insertions(+), 100 deletions(-)
 delete mode 100644 include/linux/i2c-id.h

---------------

Jean Delvare (7):
      i2c: make i2c_get_adapter prototype clearer
      i2c: Minor fixes to upgrading-clients document
      i2c: Get rid of <linux/i2c-id.h>
      i2c: Export i2c_for_each_dev
      i2c-dev: Use standard bus notification mechanism
      i2c: Deprecate i2c_driver.attach_adapter and .detach_adapter
      i2c: Drop i2c_adapter.id

Roman Fietze (1):
      i2c: Fix typo in instantiating-devices document

Seth Heasley (1):
      i2c-i801: SMBus patch for Intel DH89xxCC DeviceIDs

Wolfram Sang (1):
      i2c-boardinfo: Fix typo in comment

Thanks,
-- 
Jean Delvare
