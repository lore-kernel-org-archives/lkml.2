Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2EEOdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:33:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60542 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab2EEOc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:28 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 3/8] drivers/staging/line6/variax.c: Change strict_strtoul to kstrtoul
Date: Sat,  5 May 2012 16:31:47 +0200
Message-Id: <1336228312-5379-4-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed strict_strtoul() call to kstrtoul to make checkpatch.pl happy

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/variax.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index d366222..cf41695 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -322,7 +322,7 @@ static ssize_t variax_set_volume(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtoul(buf, 10, &value);
 	if (ret)
 		return ret;
 
@@ -356,7 +356,7 @@ static ssize_t variax_set_model(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtoul(buf, 10, &value);
 	if (ret)
 		return ret;
 
@@ -390,7 +390,7 @@ static ssize_t variax_set_active(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtoul(buf, 10, &value);
 	if (ret)
 		return ret;
 
@@ -421,7 +421,7 @@ static ssize_t variax_set_tone(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtoul(buf, 10, &value);
 	if (ret)
 		return ret;
 
-- 
1.7.7.6

