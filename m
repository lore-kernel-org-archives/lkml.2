Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1KJUiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 15:38:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65389 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1KJUiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 15:38:06 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH] drivers/platform/x86/dell-laptop.c: Remove some unneeded break statements
Date: Thu, 10 Nov 2011 18:37:07 -0200
Message-Id: <1320957427-2763-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/platform/x86/dell-laptop.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index a43cfd9..b3e9b70 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -236,9 +236,7 @@ static void __init find_tokens(const struct dmi_header *dm, void *dummy)
 {
 	switch (dm->type) {
 	case 0xd4: /* Indexed IO */
-		break;
 	case 0xd5: /* Protected Area Type 1 */
-		break;
 	case 0xd6: /* Protected Area Type 2 */
 		break;
 	case 0xda: /* Calling interface */
-- 
1.7.4.4

