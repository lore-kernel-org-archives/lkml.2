Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab0EYNbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:31:43 -0400
Received: from mail.ampazis.com ([86.35.2.10]:33221 "EHLO enigma.wired-net.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab0EYNbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:31:41 -0400
X-Greylist: delayed 1311 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 09:31:40 EDT
From: nanakos@wired-net.gr
To: gregkh@suse.de
Cc: martyn.welch@ge.com, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Nanakos Chrysostomos <nanakos@wired-net.gr>
Subject: [PATCH] Staging: vme: vme.c: fixed an EXPORT_SYMBOL warning
Date: Tue, 25 May 2010 13:09:17 +0000
Message-Id: <1274792957-4602-1-git-send-email-nanakos@wired-net.gr>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nanakos Chrysostomos <nanakos@wired-net.gr>

Fixed an EXPORT_SYMBOL warning.

Signed-off-by: Nanakos Chrysostomos <nanakos@wired-net.gr>
---
 drivers/staging/vme/vme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 093fbff..a0b63d5 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1519,7 +1519,6 @@ struct bus_type vme_bus_type = {
 	.probe = vme_bus_probe,
 	.remove = vme_bus_remove,
 };
-EXPORT_SYMBOL(vme_bus_type);
 
 static int __init vme_init(void)
 {
@@ -1530,6 +1529,7 @@ static void __exit vme_exit(void)
 {
 	bus_unregister(&vme_bus_type);
 }
+EXPORT_SYMBOL(vme_bus_type);
 
 MODULE_DESCRIPTION("VME bridge driver framework");
 MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com");
-- 
1.5.6.5

