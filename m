Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab0KOV6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:58:39 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:30501 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab0KOV6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:58:38 -0500
Date: Mon, 15 Nov 2010 22:58:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.37
Message-ID: <20101115225830.3d2b0994@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem fixes for Linux 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 drivers/i2c/i2c-core.c                     |   12 ++++++++++++
 drivers/i2c/i2c-mux.c                      |    1 -
 drivers/media/common/saa7146_i2c.c         |    1 -
 drivers/media/video/imx074.c               |    2 --
 drivers/media/video/ir-kbd-i2c.c           |    1 -
 drivers/media/video/ov6650.c               |    2 --
 drivers/misc/apds9802als.c                 |    1 -
 drivers/staging/olpc_dcon/olpc_dcon.c      |    4 ----
 drivers/video/riva/rivafb-i2c.c            |    1 -
 include/linux/i2c-id.h                     |   22 ----------------------
 include/linux/i2c.h                        |    2 +-
 12 files changed, 23 insertions(+), 36 deletions(-)

---------------

Jean Delvare (4):
      i2c: Delete unused adapter IDs
      i2c: Drivers shouldn't include <linux/i2c-id.h>
      i2c: Mark i2c_adapter.id as deprecated
      i2c: Sanity checks on adapter registration

Wolfram Sang (1):
      i2c: Remove obsolete cleanup for clientdata

Thanks,
-- 
Jean Delvare
