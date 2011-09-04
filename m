Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1IDK2E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:28:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab1IDK0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:33 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 12/12] staging: et131x: Update README file
Date: Sun,  4 Sep 2011 11:24:43 +0100
Message-Id: <1315131883-11068-13-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe that the driver is up to date with the latest network driver changes, so removing this line from the TODO to see if anyone else disagrees.

Also all useless typecasts are now dead.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index c6bcc6a..7e846b2 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -9,8 +9,6 @@ Note, the powermanagement options were removed from the vendor provided
 driver as they did not build properly at the time.
 
 TODO:
-	- forward port for latest network driver changes
-	- kill useless typecasts (e.g. in et1310_phy.c)
 	- alloc_etherdev is initializing memory with zero?!?
 	- add_timer call in et131x_netdev.c is correct?
 	- Add power saving functionality (suspend, sleep, resume)
-- 
1.7.6

