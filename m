Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab0FTH3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 03:29:54 -0400
Received: from poutre.nerim.net ([62.4.16.124]:61271 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0FTH3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 03:29:52 -0400
Date: Sun, 20 Jun 2010 09:29:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.35
Message-ID: <20100620092948.3a417672@hyperion.delvare>
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

 drivers/hwmon/i5k_amb.c |    6 ++++++
 drivers/hwmon/k10temp.c |   14 ++++++++++++--
 drivers/hwmon/k8temp.c  |    2 +-
 3 files changed, 19 insertions(+), 3 deletions(-)

---------------

Jean Delvare (2):
      hwmon: (k10temp) Do not blacklist known working CPU models
      hwmon: (k8temp) Bypass core swapping on single-core processors

KAMEZAWA Hiroyuki (1):
      hwmon: (i5k_amb) Fix sysfs attribute for lockdep

Thanks,
-- 
Jean Delvare
