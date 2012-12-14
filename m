Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2LNQHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:07:34 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:45074 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2LNQHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:07:30 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@steicsson.com>
Subject: [RFCv2 04/11] remoteproc: Add state RPROC_LOADED
Date: Fri, 14 Dec 2012 17:06:53 +0100
Message-Id: <1355501220-4572-5-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add state RPROC_LOADED as firmware loading and startup will be
different states.

Signed-off-by: Sjur Brændeland <sjur.brandeland@steicsson.com>
---
 drivers/remoteproc/remoteproc_debugfs.c |    1 +
 include/linux/remoteproc.h              |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
index 157a573..a026359 100644
--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -68,6 +68,7 @@ static const char * const rproc_state_string[] = {
 	"suspended",
 	"running",
 	"crashed",
+	"loaded",
 	"invalid",
 };
 
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index cdacd66..932edc7 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -357,7 +357,8 @@ enum rproc_state {
 	RPROC_SUSPENDED	= 1,
 	RPROC_RUNNING	= 2,
 	RPROC_CRASHED	= 3,
-	RPROC_LAST	= 4,
+	RPROC_LOADED    = 4,
+	RPROC_LAST	= 5,
 };
 
 /**
-- 
1.7.5.4

