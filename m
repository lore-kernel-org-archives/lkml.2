Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab1ESEqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 00:46:45 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:35323
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab1ESEqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 00:46:44 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: userspace: bind-driver.c: mark remote_host as unused
Date: Wed, 18 May 2011 21:46:13 -0700
Message-Id: <a66cf273cce8a4470c3350214989ed6dfdb58f59.1305780286.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __attribute__((unused)) to suppress error until it can be determined
that remote_host is not needed.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/bind-driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/bind-driver.c b/drivers/staging/usbip/userspace/src/bind-driver.c
index 955c86b..201ffbb 100644
--- a/drivers/staging/usbip/userspace/src/bind-driver.c
+++ b/drivers/staging/usbip/userspace/src/bind-driver.c
@@ -541,7 +541,7 @@ static int allusbip(void)
 int main(int argc, char **argv)
 {
 	char *busid = NULL;
-	char *remote_host = NULL;
+	char *remote_host __attribute__((unused)) = NULL;
 
 	enum {
 		cmd_unknown = 0,
-- 
1.7.5.1

