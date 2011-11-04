Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab1KDKRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:17:04 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:45927 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab1KDKQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:16:51 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 3/3] staging: vme: fix comment for struct vme_dev
Date: Fri, 4 Nov 2011 11:12:31 +0100
Message-ID: <1320401551-29287-4-git-send-email-manohar.vanga@cern.ch>
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
 drivers/staging/vme/vme.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index e3828ba..e62a323 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -97,7 +97,7 @@ extern struct bus_type vme_bus_type;
 
 /**
  * Structure representing a VME device
- * @id: The ID of the device (currently the bus and slot number)
+ * @num: The device number
  * @bridge: Pointer to the bridge device this device is on
  * @dev: Internal device structure
  * @drv_list: List of devices (per driver)
-- 
1.7.4.1

