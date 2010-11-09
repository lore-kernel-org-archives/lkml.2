Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0KIPSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:18:39 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:39657 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738Ab0KIPSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:18:36 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 11/11] hwmon: applesmc: Update copyright information
Date: Tue,  9 Nov 2010 16:15:11 +0100
Message-Id: <1289315711-3011-12-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpx6-0001Tt-AR.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PFpx6-0001Tt-AR f6e726e16f348d2133ec484dd386020c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the preceding patches, git blame assigns about half of
the file to the present author. Add a line to the copyright
to reflect this.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 576dcb4..ee91d69 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -4,6 +4,7 @@
  * computers.
  *
  * Copyright (C) 2007 Nicolas Boichat <nicolas@boichat.ch>
+ * Copyright (C) 2010 Henrik Rydberg <rydberg@euromail.se>
  *
  * Based on hdaps.c driver:
  * Copyright (C) 2005 Robert Love <rml@novell.com>
-- 
1.7.1

