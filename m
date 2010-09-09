Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0IIW54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:57:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab0IIWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C4PIVeeMDD/GYBks1+GU0SAVVLHpEr5W/k4jrqN8ODMSdyLRTFBfr9QTYJ3U2zj+6g
         MOw4tficR+6kiVRGJJ7kuvcnz7I/Z4QcdihsoT6ac90s/uLxWq4B2MchCGXbSA7wz6PA
         kf3qqmLTA8nsTgja30l/xuO+CRiOBxevLZlGY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 132/223]drivers/serial/8250.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:39 -0700
Message-Id: <1284071862-8194-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 24110f6..538f13f 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -924,7 +924,7 @@ static int broken_efr(struct uart_8250_port *up)
 	/*
 	 * Exar ST16C2550 "A2" devices incorrectly detect as
 	 * having an EFR, and report an ID of 0x0201.  See
-	 * http://www.exar.com/info.php?pdf=dan180_oct2004.pdf
+	 * http://www.exar.com/ 
 	 */
 	if (autoconfig_read_divisor_id(up) == 0x0201 && size_fifo(up) == 16)
 		return 1;
-- 
1.7.2.1

