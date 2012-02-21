Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2BUGaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 01:30:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48738 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2BUGaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 01:30:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hitoshi.nakamori@gmail.com designates 10.68.208.136 as permitted sender) smtp.mail=hitoshi.nakamori@gmail.com; dkim=pass header.i=hitoshi.nakamori@gmail.com
From: Hitoshi NAKAMORI <hitoshi.nakamori@gmail.com>
To: gregkh@linuxfoundation.org, d@teklibre.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hitoshi NAKAMORI <hitoshi.nakamori@gmail.com>
Subject: [PATCH] Staging: frontier: Fix checkpatch.pl issue. 
Date: Tue, 21 Feb 2012 15:31:04 +0900
Message-Id: <1329805864-21155-1-git-send-email-hitoshi.nakamori@gmail.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the alphatrack.c and tranzport.c  that fixes up an error
 found by checkpatch.pl tool. 
Signed-off-by: Hitoshi Nakamori <hitoshi.nakamori@gmail.com>

---
 drivers/staging/frontier/alphatrack.c |    2 +-
 drivers/staging/frontier/tranzport.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index d8efed6..3bf0f40e 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -450,7 +450,7 @@ exit:
 /**
  *	usb_alphatrack_poll
  */
-static unsigned int usb_alphatrack_poll(struct file *file, poll_table * wait)
+static unsigned int usb_alphatrack_poll(struct file *file, poll_table *wait)
 {
 	struct usb_alphatrack *dev;
 	unsigned int mask = 0;
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index cf47a5d..29e99bb 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -471,7 +471,7 @@ exit:
 /**
  *	usb_tranzport_poll
  */
-static unsigned int usb_tranzport_poll(struct file *file, poll_table * wait)
+static unsigned int usb_tranzport_poll(struct file *file, poll_table *wait)
 {
 	struct usb_tranzport *dev;
 	unsigned int mask = 0;
-- 
1.7.8.3

