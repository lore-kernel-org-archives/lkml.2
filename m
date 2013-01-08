Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3AHXhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:63575 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab3AHXhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Qinglin Ye <yestyle@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 36/77] USB: usb-storage: unusual_devs entry for Kingston DT 101 G2
Date: Tue, 8 Jan 2013 18:35:15 -0500
Message-ID: <1357688156-25387-37-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qinglin Ye <yestyle@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cec28a5428793b6bc64e56687fb239759d6da74e upstream.

Kingston DT 101 G2 replies a wrong tag while transporting, add an
unusal_devs entry to ignore the tag validation.

Signed-off-by: Qinglin Ye <yestyle@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index ee5a8ba..5d360f4 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1852,6 +1852,13 @@ UNUSUAL_DEV(  0x1370, 0x6828, 0x0110, 0x0110,
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* Reported by Qinglin Ye <yestyle@gmail.com> */
+UNUSUAL_DEV(  0x13fe, 0x3600, 0x0100, 0x0100,
+		"Kingston",
+		"DT 101 G2",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_BULK_IGNORE_TAG ),
+
 /* Reported by Francesco Foresti <frafore@tiscali.it> */
 UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x0201,
 		"Super Top",
-- 
1.7.12.1

