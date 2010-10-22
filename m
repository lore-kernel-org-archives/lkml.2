Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab0JVHQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:16:35 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:49493 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0JVHQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:16:34 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 13/30] staging/vme_user: declare private variables as static
Date: Fri, 22 Oct 2010 02:36:35 -0400
Message-Id: <1287729412-24356-14-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/devices/vme_user.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index bdc4e1e..31a74e2 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -114,9 +114,9 @@ typedef struct {
 } driver_stats_t;
 static driver_stats_t statistics;
 
-struct cdev *vme_user_cdev;		/* Character device */
-struct class *vme_user_sysfs_class;	/* Sysfs class */
-struct device *vme_user_bridge;		/* Pointer to the bridge device */
+static struct cdev *vme_user_cdev;		/* Character device */
+static struct class *vme_user_sysfs_class;	/* Sysfs class */
+static struct device *vme_user_bridge;		/* Pointer to the bridge device */
 
 
 static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
-- 
1.7.1

