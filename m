Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab1KDKRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:17:24 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:42154 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1KDKQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:16:48 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 1/3] staging: vme: fix comment in __vme_register_driver()
Date: Fri, 4 Nov 2011 11:12:29 +0100
Message-ID: <1320401551-29287-2-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1320401551-29287-1-git-send-email-manohar.vanga@cern.ch>
References: <1320401551-29287-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/vme.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index b04b468..3cbc69c 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1421,10 +1421,7 @@ static int __vme_register_driver(struct vme_driver *drv, unsigned int ndevs)
 		 * and if the bridge is removed, it will have to go through
 		 * vme_unregister_bridge() to do it (which calls remove() on
 		 * the bridge which in turn tries to acquire vme_buses_lock and
-		 * will have to wait). The probe() called after device
-		 * registration in __vme_register_driver below will also fail
-		 * as the bridge is being removed (since the probe() calls
-		 * vme_bridge_get()).
+		 * will have to wait).
 		 */
 		err = __vme_register_driver_bus(drv, bridge, ndevs);
 		if (err)
-- 
1.7.4.1

