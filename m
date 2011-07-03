Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1GCMC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 08:02:27 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1150 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1GCMC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 08:02:26 -0400
Date: Sun, 3 Jul 2011 14:02:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 3.0
Message-ID: <20110703140213.71def431@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.0 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 Documentation/hwmon/f71882fg |    4 +++
 Documentation/hwmon/k10temp  |    8 ++++-
 drivers/hwmon/Kconfig        |    2 +-
 drivers/hwmon/emc6w201.c     |   58 +++++++++++++++++++++++++++++++----------
 drivers/hwmon/f71882fg.c     |   19 +++++++++++--
 drivers/hwmon/hwmon-vid.c    |    2 +-
 drivers/hwmon/sch5627.c      |    2 +-
 7 files changed, 73 insertions(+), 22 deletions(-)

---------------

Clemens Ladisch (1):
      hwmon: (k10temp) Update documentation for Fam12h

Hans de Goede (2):
      hwmon: Use <> rather than () around my e-mail address
      hwmon: (f71882fg) Add support for the F71869A

Jean Delvare (2):
      hwmon: (emc6w201) Properly handle all errors
      hwmon-vid: Fix typo in VIA CPU name

Thanks,
-- 
Jean Delvare
