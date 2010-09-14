Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0INEZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:25:08 -0400
Received: from mail.perches.com ([173.55.12.10]:2010 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab0INEYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:19 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH next 12/16] drivers/usb: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:58 -0700
Message-Id: <84f23080775f186887489722fd2a3af4a3af3974.1284435710.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/host/oxu210hp-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 8026dc8..32149be 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3687,7 +3687,7 @@ static void oxu_configuration(struct platform_device *pdev, void *base)
 static int oxu_verify_id(struct platform_device *pdev, void *base)
 {
 	u32 id;
-	char *bo[] = {
+	static const char * const bo[] = {
 		"reserved",
 		"128-pin LQFP",
 		"84-pin TFBGA",
-- 
1.7.3.rc1

