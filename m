Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab0JaHxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 03:53:38 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:48021 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab0JaHxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 03:53:34 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 8/8] hwmon: applesmc: Update copyright information
Date: Sun, 31 Oct 2010 08:50:34 +0100
Message-Id: <1288511434-5662-9-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PCSii-0002zs-9v.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PCSii-0002zs-9v 4983344bd346374db705bad733f6be21
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
index c09cd2e..7ae37eb 100644
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

