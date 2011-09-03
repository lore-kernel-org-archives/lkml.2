Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1ICLup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 07:50:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35524 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1ICLuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 07:50:35 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/2] staging: et131x: Amend README file
Date: Sat,  3 Sep 2011 12:49:07 +0100
Message-Id: <1315050547-4781-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315050547-4781-1-git-send-email-mark.einon@gmail.com>
References: <1315050547-4781-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the kernel style cleanups are done now.
Adding myself as a recipient of patches.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index 28752a5..c6bcc6a 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -9,7 +9,6 @@ Note, the powermanagement options were removed from the vendor provided
 driver as they did not build properly at the time.
 
 TODO:
-	- kernel coding style cleanups
 	- forward port for latest network driver changes
 	- kill useless typecasts (e.g. in et1310_phy.c)
 	- alloc_etherdev is initializing memory with zero?!?
@@ -19,6 +18,7 @@ TODO:
 
 Please send patches to:
 	Greg Kroah-Hartman <gregkh@suse.de>
+	Mark Einon <mark.einon@gmail.com>
 
 And Cc: Olaf Hartmann <o.hartmann@telovital.com> as he has this device and can
 test any changes.
-- 
1.7.6

