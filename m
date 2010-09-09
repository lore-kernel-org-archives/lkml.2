Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab0IIWiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:38:04 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44888 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893Ab0IIWhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ah1scYQtGgd2ZYXemUbQ72HwqU6NKZNBUunbCf9dkA6afuJnBc1E13kBNhSuiWyMmX
         t/AbUmVVPCkOAKadrn+JWm67wjHxEjKkiWvAW53PRXnoYd38KuKOebWt2Sv2b0sIA5v4
         Nv9/1usptGP5W7fSalgF0fuCTmegTwsClvLeo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 135/223]drivers/serial/bfin_sport_uart.h Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:42 -0700
Message-Id: <1284071862-8194-15-git-send-email-justinmattock@gmail.com>
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
 drivers/serial/bfin_sport_uart.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport_uart.h
index 9ce253e..6d06ce1 100644
--- a/drivers/serial/bfin_sport_uart.h
+++ b/drivers/serial/bfin_sport_uart.h
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

