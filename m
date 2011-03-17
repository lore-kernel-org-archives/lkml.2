Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1CQUfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:35:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41625 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1CQUfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eJjtGqo0SEXq/ZYMsyM3z9Sb2o7LadNTUHxzdfWhW7IBcFL2YC8Q/SXuX4up53XczI
         BIz/2iy5C2QeY3/lRnZlPzYkOmJxiZ4x42Yfwb771jCB6uIgZz9AKTrQUWiajxXDIauk
         Mj/1m6efJuxS3ouzqrWee87FM8x8eo6Pb9C9A=
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: malattia@linux.it
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, trivial@vger.kernel.org
Subject: [PATCH] sonypi: fix common misspellings
Date: Thu, 17 Mar 2011 17:35:40 -0300
Message-Id: <1300394140-2116-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 drivers/char/sonypi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 79e36c8..1ee8ce7 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -1241,7 +1241,7 @@ static int __devinit sonypi_setup_ioports(struct sonypi_device *dev,
 	while (check_ioport && check->port1) {
 		if (!request_region(check->port1,
 				   sonypi_device.region_size,
-				   "Sony Programable I/O Device Check")) {
+				   "Sony Programmable I/O Device Check")) {
 			printk(KERN_ERR "sonypi: ioport 0x%.4x busy, using sony-laptop? "
 					"if not use check_ioport=0\n",
 					check->port1);
@@ -1255,7 +1255,7 @@ static int __devinit sonypi_setup_ioports(struct sonypi_device *dev,
 
 		if (request_region(ioport_list->port1,
 				   sonypi_device.region_size,
-				   "Sony Programable I/O Device")) {
+				   "Sony Programmable I/O Device")) {
 			dev->ioport1 = ioport_list->port1;
 			dev->ioport2 = ioport_list->port2;
 			return 0;
-- 
1.7.4.1

