Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab0HYPAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:00:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31273 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0HYPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:00:05 -0400
Date: Wed, 25 Aug 2010 16:59:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.36
Message-ID: <20100825165951.0c5d0955@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.36 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 MAINTAINERS              |    3 +--
 drivers/hwmon/ads7871.c  |   38 +++++++++++++++++++-------------------
 drivers/hwmon/coretemp.c |    1 -
 drivers/hwmon/k8temp.c   |   35 ++++++++++++++++++++++++++++++++---
 4 files changed, 52 insertions(+), 25 deletions(-)

---------------

Andreas Herrmann (1):
      hwmon: (k8temp) Differentiate between AM2 and ASB1

Axel Lin (1):
      hwmon: (ads7871) Fix ads7871_probe error paths

Fenghua Yu (1):
      MAINTAINERS: hwmon/coretemp: Change maintainers

Jean Delvare (1):
      hwmon: (coretemp) Fix harmless build warning

Thanks,
-- 
Jean Delvare
