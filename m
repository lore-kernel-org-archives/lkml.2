Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab1FWRWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:62775 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759864Ab1FWRWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 012/247] USB: usb-storage: unusual_devs entry for Coby MP3 player
Date: Thu, 23 Jun 2011 13:17:35 -0400
Message-Id: <1308849690-14530-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3ea3c9b5a8464ec8223125f95e5dddb3bfd02a39 upstream.

This patch (as1444) adds an unusual_devs entry for an MP3 player from
Coby electronics.  The device has two nasty bugs.

[PG: change USB_ --> US_ to match 2.6.34.x naming conventions]

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Jasper Mackenzie <scarletpimpernal@hotmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index ee6e67e..ce8b52a 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1893,6 +1893,13 @@ UNUSUAL_DEV(  0x1e68, 0x001b, 0x0000, 0x0000,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
 
+/* Reported by Jasper Mackenzie <scarletpimpernal@hotmail.com> */
+UNUSUAL_DEV( 0x1e74, 0x4621, 0x0000, 0x0000,
+		"Coby Electronics",
+		"MP3 Player",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",
-- 
1.7.4.4

