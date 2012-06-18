Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2FRQTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:19:51 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47848 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab2FRQTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:43 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 19/22] UBI: Fastmap: Init fm_sem
Date: Mon, 18 Jun 2012 18:19:02 +0200
Message-Id: <1340036345-96726-20-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...forgot to stage this change.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/build.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 0ad6789..1ad128d 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -908,6 +908,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 	mutex_init(&ubi->device_mutex);
 	mutex_init(&ubi->fm_pool_mutex);
 	mutex_init(&ubi->fm_mutex);
+	init_rwsem(&ubi->fm_sem);
 	spin_lock_init(&ubi->volumes_lock);
 
 	ubi_msg("attaching mtd%d to ubi%d", mtd->index, ubi_num);
-- 
1.7.6.5

