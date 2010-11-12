Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0KLLPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:15:21 -0500
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:36845 "EHLO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab0KLLPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:15:16 -0500
Subject: [PATCH 11/17] staging/vme_user: declare private variables as static
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:15:14 +0000
Message-ID: <20101112111514.11631.21637.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
[martyn.welch@ge.com: modified to remove checkpatch warnings]
Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/devices/vme_user.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index bdc4e1e..f7fa02d 100644
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
+static struct device *vme_user_bridge;		/* Pointer to bridge device */
 
 
 static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
