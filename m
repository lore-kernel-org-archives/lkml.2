Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1CZKFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 06:05:33 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25321 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1CZKFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 06:05:32 -0400
Date: Sat, 26 Mar 2011 11:05:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] More hwmon updates for 2.6.39
Message-ID: <20110326110518.5c631e12@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull more hwmon subsystem updates for Linux 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

We have support for two new devices: Fintek F71889A and F81865F.

 Documentation/hwmon/f71882fg |   19 ++++++
 drivers/hwmon/Kconfig        |   17 +++++-
 drivers/hwmon/f71882fg.c     |  126 ++++++++++++++++++++++++++++--------------
 3 files changed, 117 insertions(+), 45 deletions(-)

---------------

Hans de Goede (1):
      hwmon: (f71882fg) Add support for the F71889A

Jean Delvare (4):
      hwmon: (f71882fg) Secure chip property definition arrays
      hwmon: (f71882fg) Per-chip fan/temperature input count tables
      hwmon: (f71882fg) Document all supported devices
      hwmon: (f71882fg) Add support for the F81865F

Thanks,
-- 
Jean Delvare
