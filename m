Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab2EEOdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:33:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab2EEOc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:27 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 2/8] drivers/staging/line6/pod.c: Change strict_strtoul to kstrtoul
Date: Sat,  5 May 2012 16:31:46 +0200
Message-Id: <1336228312-5379-3-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed strict_strtoul() call to kstrtoul to make checkpatch.pl happy

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/pod.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 4dadc57..d61b253 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -438,7 +438,7 @@ static int pod_resolve(const char *buf, short block0, short block1,
 	short block;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtoul(buf, 10, &value);
 	if (ret)
 		return ret;
 
@@ -563,7 +563,7 @@ static ssize_t pod_set_channel(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtoul(buf, 10, &value);
 	if (ret)
 		return ret;
 
@@ -895,7 +895,7 @@ static ssize_t pod_set_midi_postprocess(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &value);
+	ret = kstrtoul(buf, 10, &value);
 	if (ret)
 		return ret;
 
-- 
1.7.7.6

