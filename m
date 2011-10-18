Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab1JRQN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:13:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34731 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab1JRQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:09:57 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [RESEND][PATCH 10/26] staging: et131x: Update TODO list - remove 'put driver into single file'
Date: Tue, 18 Oct 2011 17:07:43 +0100
Message-Id: <1318954079-16666-11-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver now resides in a single file with a separate header with
registers, updated the README TODO list.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index c67f83e..a7b33dc 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -8,7 +8,6 @@ Note, the powermanagement options were removed from the vendor provided
 driver as they did not build properly at the time.
 
 TODO:
-	- Put the driver into a single file, with a .h for the registers layout.
 	- rx_ring.fbr{0, 1} can probably share a common structure
 	- Use of kmem_cache seems a bit unusual
 	- Use dma_alloc_... in place of pci_alloc_...
-- 
1.7.6.4

