Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab1FWSeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:34:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:62692 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759794Ab1FWRVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:21:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        =?UTF-8?q?Richard=20Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 009/247] USB: usb-storage: unusual_devs update for Cypress ATACB
Date: Thu, 23 Jun 2011 13:17:32 -0400
Message-Id: <1308849690-14530-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Schütz <r.schtz@t-online.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cae41118f50ef0c431e13159df6d7dd8bbd54004 upstream.

New device ID added for unusual Cypress ATACB device.

[PG: change USB_ --> US_ to match 2.6.34.x naming conventions]

Signed-off-by: Richard Schütz <r.schtz@t-online.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/storage/unusual_cypress.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/storage/unusual_cypress.h b/drivers/usb/storage/unusual_cypress.h
index 44be6d7..fba2824 100644
--- a/drivers/usb/storage/unusual_cypress.h
+++ b/drivers/usb/storage/unusual_cypress.h
@@ -31,4 +31,9 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x9999,
 		"Cypress ISD-300LP",
 		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),
 
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x9999,
+		"Super Top",
+		"USB 2.0  SATA BRIDGE",
+		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),
+
 #endif /* defined(CONFIG_USB_STORAGE_CYPRESS_ATACB) || ... */
-- 
1.7.4.4

