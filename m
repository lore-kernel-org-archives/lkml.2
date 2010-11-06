Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0KFTBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:01:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46996 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0KFTBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cBY06CXd0qx6XhMmarfdx2gRVlH5ac6iokfi8U8zfkJS1Fgc3I0QTcp/OXDA807kQJ
         iVaVyDYCEa7x1Fz7nDeBTCUvbVh6ojaIWvq1JWPHFH1BESyH23yQ2wxOP3zAv2QyuQVC
         WpVzTbrbK4h9p6GngKR5oRnAl8Xa5Mcpu/HZA=
From: Tracey Dent <tdent48227@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Drivers: dca: Makefile: Cleaned up Makefile
Date: Sat,  6 Nov 2010 15:01:57 -0400
Message-Id: <1289070117-2461-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/dca/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dca/Makefile b/drivers/dca/Makefile
index b2db56b..862b5c2 100644
--- a/drivers/dca/Makefile
+++ b/drivers/dca/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_DCA) += dca.o
-dca-objs := dca-core.o dca-sysfs.o
+dca-y := dca-core.o dca-sysfs.o
-- 
1.7.3.1.104.gc752e

