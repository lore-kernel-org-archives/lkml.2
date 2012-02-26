Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2BZPHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 10:07:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34576 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab2BZPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 10:07:22 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: balbi@ti.com
Cc: dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 5/6] amd5536udc: Fix the type of ep_string.
Date: Sun, 26 Feb 2012 16:00:25 +0100
Message-Id: <1330268425-4260-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <4F48FD62.7090304@mvista.com>
References: <4F48FD62.7090304@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "static const char *const" instead of "static const char *".

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/usb/gadget/amd5536udc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 3d563d0..16079bd 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -140,7 +140,7 @@ static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect,
 
 /* endpoint names used for print */
 static const char ep0_string[] = "ep0in";
-static const char *ep_string[] = {
+static const char *const ep_string[] = {
 	ep0_string,
 	"ep1in-int", "ep2in-bulk", "ep3in-bulk", "ep4in-bulk", "ep5in-bulk",
 	"ep6in-bulk", "ep7in-bulk", "ep8in-bulk", "ep9in-bulk", "ep10in-bulk",
-- 
1.7.9

