Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab0IIWhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:37:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59224 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab0IIWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Kd+LHefwgyUYLx4+amueA1fBq8vPBQskr/v80+6twWMhL3CBdJtHcH3/uEzcYnx6vF
         r+IN67WkuBgQMQqXs0rxD7h+hxe8WJ4cQPrG7MUBTYmbUbEmEqGyu/CgBiACnfcX5aNI
         kjeSECxkPGbH8zCstcc7uAbPb47ool/J4Ahj0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 133/223]drivers/serial/bfin_sport_uart.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:40 -0700
Message-Id: <1284071862-8194-13-git-send-email-justinmattock@gmail.com>
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
 drivers/serial/bfin_sport_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index e57fb3d..5c0aed5 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -10,7 +10,7 @@
 
 /*
  * This driver and the hardware supported are in term of EE-191 of ADI.
- * http://www.analog.com/UploadedFiles/Application_Notes/399447663EE191.pdf
+ * http://www.analog.com/static/imported-files/application_notes/EE191.pdf
  * This application note describe how to implement a UART on a Sharc DSP,
  * but this driver is implemented on Blackfin Processor.
  * Transmit Frame Sync is not used by this driver to transfer data out.
-- 
1.7.2.1

