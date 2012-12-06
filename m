Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947032Ab2LFTfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:35:43 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59896 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946556Ab2LFTfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:35:41 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@steicsson.com>
Subject: [RFC 3/5] remoteproc: Add state RPROC_LOADED
Date: Thu,  6 Dec 2012 20:35:22 +0100
Message-Id: <1354822524-4497-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354822524-4497-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1354822524-4497-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add state RPROC_LOADED. Prepare for the state when the firmware
is loaded, but remote device is not started.

Signed-off-by: Sjur Brændeland <sjur.brandeland@steicsson.com>
---
 drivers/remoteproc/remoteproc_debugfs.c |    1 +
 include/linux/remoteproc.h              |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

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
index faf3332..17b8120 100644
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
1.7.9.5

