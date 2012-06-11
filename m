Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2FKA7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:42 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40539 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab2FKA6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:30 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 06/14] sta2x11-mfd, sta2x11-mfd.h: add more platform device types
Date: Mon, 11 Jun 2012 02:57:51 +0200
Message-Id: <1339376279-16753-7-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>


Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 include/linux/mfd/sta2x11-mfd.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index 2867d55..4b2667a 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -28,8 +28,12 @@
 
 enum sta2x11_mfd_plat_dev {
 	sta2x11_sctl = 0,
-	sta2x11_apbreg = 1,
-	sta2x11_apb_soc_regs = 2,
+	sta2x11_gpio,
+	sta2x11_scr,
+	sta2x11_time,
+	sta2x11_apbreg,
+	sta2x11_apb_soc_regs,
+	sta2x11_vic,
 	sta2x11_n_mfd_plat_devs,
 };
 
-- 
1.7.9.1

