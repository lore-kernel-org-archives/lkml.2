Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2HOTuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:36580 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2HOTt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Marek Vasut <marek.vasut@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 047/165] ASIX: Add AX88772B USB ID
Date: Wed, 15 Aug 2012 15:46:31 -0400
Message-ID: <1345060109-9187-48-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Vasut <marek.vasut@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 308859097831831a979f2e82cbeef0a94f438080 upstream.

This device can be found in Acer Iconia TAB W500 tablet dock.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/usb/asix.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index 35f56fc..60e882f 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1473,6 +1473,10 @@ static const struct usb_device_id	products [] = {
 	USB_DEVICE (0x04f1, 0x3008),
 	.driver_info = (unsigned long) &ax8817x_info,
 }, {
+	// ASIX AX88772B 10/100
+	USB_DEVICE (0x0b95, 0x772b),
+	.driver_info = (unsigned long) &ax88772_info,
+}, {
 	// ASIX AX88772 10/100
 	USB_DEVICE (0x0b95, 0x7720),
 	.driver_info = (unsigned long) &ax88772_info,
-- 
1.7.12.rc2

