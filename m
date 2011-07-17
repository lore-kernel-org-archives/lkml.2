Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab1GQVLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 17:11:21 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:7305 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab1GQVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 17:11:19 -0400
Date: Sun, 17 Jul 2011 23:11:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 3.0
Message-ID: <20110717231106.7fac2569@endymion.delvare>
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

 drivers/hwmon/asus_atk0110.c |    1 +
 drivers/hwmon/it87.c         |    2 +-
 drivers/hwmon/max1111.c      |   11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletions(-)

---------------

Jean Delvare (1):
      hwmon: (it87) Fix label group removal

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Fix memory leak

Pavel Herrmann (1):
      hwmon: (max1111) Fix race condition causing NULL pointer exception

Thanks,
-- 
Jean Delvare
