Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2EEOco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:32:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33050 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2EEOcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:23 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 1/8] drivers/staging/line6/control.c: Change strict_strtoul to kstrtoul
Date: Sat,  5 May 2012 16:31:45 +0200
Message-Id: <1336228312-5379-2-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed strict_strtoul() call to kstrtoul to make checkpatch.pl happy

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/control.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/control.c b/drivers/staging/line6/control.c
index 67e23b6..c2e4619 100644
--- a/drivers/staging/line6/control.c
+++ b/drivers/staging/line6/control.c
@@ -58,7 +58,7 @@ static ssize_t pod_set_param_int(struct device *dev, const char *buf,
 	unsigned long value;
 	int retval;
 
-	retval = strict_strtoul(buf, 10, &value);
+	retval = kstrtoul(buf, 10, &value);
 	if (retval)
 		return retval;
 
-- 
1.7.7.6

