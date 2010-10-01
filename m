Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab0JAMG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:06:29 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:7868 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab0JAMG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:06:28 -0400
Date: Fri, 1 Oct 2010 14:06:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.36
Message-ID: <20101001140619.28d96040@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem fixes for Linux 2.6.36 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/busses/i2c-cpm.c           |    5 +++
 drivers/i2c/busses/i2c-ibm_iic.c       |    3 ++
 drivers/i2c/busses/i2c-mpc.c           |    1 +
 drivers/i2c/busses/i2c-pca-isa.c       |   12 +++++--
 drivers/i2c/busses/i2c-pca-platform.c  |   11 ++++--
 drivers/i2c/i2c-core.c                 |   54 ++++++++++++++-----------------
 drivers/misc/bh1780gli.c               |    1 -
 drivers/regulator/ad5398.c             |    1 -
 drivers/regulator/isl6271a-regulator.c |    2 -
 drivers/rtc/rtc-ds3232.c               |    2 -
 10 files changed, 48 insertions(+), 44 deletions(-)

---------------

Grant Likely (1):
      of/i2c: Fix module load order issue caused by of_i2c.c

Rajendra Nayak (1):
      i2c: Fix checks which cause legacy suspend to never get called

Vishwanath BS (1):
      i2c: Fix for suspend/resume issue

Wolfram Sang (1):
      i2c: Remove obsolete cleanup for clientdata

Yegor Yefremov (1):
      i2c-pca: Fix waitforcompletion() return value

Thanks,
-- 
Jean Delvare
