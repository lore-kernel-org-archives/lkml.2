Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab2CSPSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:18:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43922 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab2CSPSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:18:02 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, "Justin P. Mattock" <justinmattock@gmail.com>,
        Julian Andres Klode <jak@jak-linux.org>
Subject: [PATCH 1/5]NEXT:drivers:staging:nvec:nvec.h Fix typos in staging:nvec
Date: Mon, 19 Mar 2012 08:17:49 -0700
Message-Id: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo I found while reading.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Julian Andres Klode <jak@jak-linux.org>
---
 drivers/staging/nvec/nvec.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/nvec/nvec.h b/drivers/staging/nvec/nvec.h
index a4c17b0..ba6ed8f 100644
--- a/drivers/staging/nvec/nvec.h
+++ b/drivers/staging/nvec/nvec.h
@@ -42,7 +42,7 @@
  * enum nvec_event_size - The size of an event message
  * @NVEC_2BYTES: The message has one command byte and one data byte
  * @NVEC_3BYTES: The message has one command byte and two data bytes
- * @NVEC_VAR_SIZE: The message has one command byte, one count byte, and as
+ * @NVEC_VAR_SIZE: The message has one command byte, one count byte, and has
  *                 up to as many bytes as the number in the count byte. The
  *                 maximum is 32
  *
-- 
1.7.5.4

