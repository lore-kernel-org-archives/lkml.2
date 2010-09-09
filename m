Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0IIW1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:27:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41812 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab0IIW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qcWh8BOs34u0rZSbKsNELJeL8Ho9151AawTRs3ebmjYgv9TydrzPmObai64q4iEwTA
         1MICtZez/IrC6FhRPeKWk7ohhd2bsvrhSn1m5Avz/tbYfo+rUg9GuYzBDD3ZBel3Xa/Z
         glthMkq2YVWmeHFurROfPDVTCb6LyPU1q2zOo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 014/223]drivers/edac/i82443bxgx_edac.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:24:50 -0700
Message-Id: <1284071091-7676-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
References: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/edac/i82443bxgx_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index a2fa1fe..adb6574 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -12,7 +12,7 @@
  * 440GX fix by Jason Uhlenkott <juhlenko@akamai.com>.
  *
  * Written with reference to 82443BX Host Bridge Datasheet:
- * http://www.intel.com/design/chipsets/440/documentation.htm
+ * http://ark.intel.com/Product.aspx?id=27151 
  * references to this document given in [].
  *
  * This module doesn't support the 440LX, but it may be possible to
-- 
1.7.2.1

