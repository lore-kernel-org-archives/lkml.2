Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab1IBD5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:57:33 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35020 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1IBD5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:57:31 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 03/19] Staging: cx25821: Delete file cx25821-gpio.h
Date: Fri,  2 Sep 2011 11:55:31 +0800
Message-Id: <1314935747-6881-4-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete file cx25821-gpio.h since it is not used.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-gpio.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
 delete mode 100644 drivers/staging/cx25821/cx25821-gpio.h

diff --git a/drivers/staging/cx25821/cx25821-gpio.h b/drivers/staging/cx25821/cx25821-gpio.h
deleted file mode 100644
index ca07644..0000000
--- a/drivers/staging/cx25821/cx25821-gpio.h
+++ /dev/null
@@ -1,2 +0,0 @@
-
-void cx25821_gpio_init(struct athena_dev *dev);
-- 
1.7.0.4

