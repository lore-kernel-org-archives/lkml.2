Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1LISW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:22:27 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60485 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1LISW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:22:26 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-kernel@vger.kernel.org, gregkh@suse.de, devel@driverdev.osuosl.org
Cc: arnaud.patard@rtp-net.org
Subject: [PATCH] MAINTAINERS: update xgifb maintainer's e-mail address
Date: Fri,  9 Dec 2011 20:22:04 +0200
Message-Id: <1323454924-20453-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All patches sent to the maintainer address bounce:

   Diagnostic-Code: smtp; 550 5.1.1 <apatard@mandriva.com>: Recipient address
       rejected: User unknown in virtual mailbox table

The address found in drivers/staging/xgifb/TODO seems to work better.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: arnaud.patard@rtp-net.org
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4475602..2385253 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6419,7 +6419,7 @@ S:	Odd Fixes
 F:	drivers/staging/winbond/
 
 STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
-M:	Arnaud Patard <apatard@mandriva.com>
+M:	Arnaud Patard <arnaud.patard@rtp-net.org>
 S:	Odd Fixes
 F:	drivers/staging/xgifb/
 
-- 
1.7.2.5

