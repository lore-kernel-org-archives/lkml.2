Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967082Ab2EPKXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:23:39 -0400
Received: from skyrme.org ([193.175.80.135]:36912 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967019Ab2EPKXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:23:35 -0400
Date: 16 May 2012 09:41:17 +0000
Message-Id: <1337161280-28953-3-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, hannes@cmpxchg.org, shess@hessware.de,
        "Oskar Schirmer" <oskar@scara.com>,
        "Jean Delvare" <khali@linux-fr.org>
Subject: [PATCH 2/5] i2c: Change mail address of Oskar Schirmer
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1337161280-28953-1-git-send-email-oskar@scara.com>
References: <1337161280-28953-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That old mail address doesnt exist any more.
This changes all occurences to my new address.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: Jean Delvare <khali@linux-fr.org>
---
 drivers/i2c/busses/i2c-s6000.c |    2 +-
 drivers/i2c/busses/i2c-s6000.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s6000.c b/drivers/i2c/busses/i2c-s6000.c
index c64ba73..b76a29d 100644
--- a/drivers/i2c/busses/i2c-s6000.c
+++ b/drivers/i2c/busses/i2c-s6000.c
@@ -3,7 +3,7 @@
  *
  * Description: Driver for S6000 Family I2C Interface
  * Copyright (c) 2008 emlix GmbH
- * Author:	Oskar Schirmer <os@emlix.com>
+ * Author:	Oskar Schirmer <oskar@scara.com>
  *
  * Partially based on i2c-bfin-twi.c driver by <sonic.zhang@analog.com>
  * Copyright (c) 2005-2007 Analog Devices, Inc.
diff --git a/drivers/i2c/busses/i2c-s6000.h b/drivers/i2c/busses/i2c-s6000.h
index ff23b81..4936f9f 100644
--- a/drivers/i2c/busses/i2c-s6000.h
+++ b/drivers/i2c/busses/i2c-s6000.h
@@ -6,7 +6,7 @@
  * for more details.
  *
  * Copyright (C) 2008 Emlix GmbH <info@emlix.com>
- * Author:	Oskar Schirmer <os@emlix.com>
+ * Author:	Oskar Schirmer <oskar@scara.com>
  */
 
 #ifndef __DRIVERS_I2C_BUSSES_I2C_S6000_H
-- 
1.7.5.4

