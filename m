Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1BYGOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:14:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37408 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1BYGOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:14:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Aof385KmX0zwsS9MNIWrjHkYAy3E0saBb1roTPdAtSPkSbFSQWBKGKBHn9Rjf6MqZK
         ERSV13BH9tQO/3/GvyDq8AqzQPgzMXZbOGoB5fkUefmJQoNQwPRfYRSSZuzaMFRsoCDY
         kdmWbnbXlfGdiiwOCdWl6zY+lTR4GbOrW9vuE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 15/21]drivers:staging:rtl8712:rtl871x_pwrctrl.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:14:23 -0800
Message-Id: <1298614463-4035-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8712/rtl871x_pwrctrl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_pwrctrl.c b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
index 9244c8a..23e72a0 100644
--- a/drivers/staging/rtl8712/rtl871x_pwrctrl.c
+++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
@@ -92,7 +92,7 @@ void r8712_set_ps_mode(struct _adapter *padapter, uint ps_mode, uint smart_ps)
  *
  * This will be called when CPWM interrupt is up.
  *
- * using to update cpwn of drv; and drv willl make a decision to up or
+ * using to update cpwn of drv; and drv will make a decision to up or
  * down pwr level
  */
 void r8712_cpwm_int_hdl(struct _adapter *padapter,
-- 
1.7.4.1

