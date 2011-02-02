Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1BBFHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:07:46 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58600 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1BBFHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:07:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=L5HxTGbORZfwx9AHGxyvHJ/WFC7rxj81+wTgLurS4FMyfvs3w2mo+6BZnpVRa2kVDP
         XJkuKodgAFFuf44Y2D2glSI40eLLWUt1R944GpAvUAyBr7PELYBClDObZFTg2lvT41rE
         dJJhEY7/gK360OL8JQ0ilj5nQqDaQhAS7vo3M=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: henryp@broadcom.com, gregkh@suse.de, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 6/8]drivers:staging:brcm80211i:sbsdio.h change a typo comamnd to command
Date: Tue,  1 Feb 2011 21:07:28 -0800
Message-Id: <1296623248-5399-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo comamnd to command.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/brcm80211/include/sbsdio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/include/sbsdio.h b/drivers/staging/brcm80211/include/sbsdio.h
index 6afdbbe..c190acb 100644
--- a/drivers/staging/brcm80211/include/sbsdio.h
+++ b/drivers/staging/brcm80211/include/sbsdio.h
@@ -144,7 +144,7 @@
 						 */
 
 #define SBSDIO_BYTEMODE_DATALEN_MAX	64	/* sdio byte mode: maximum length of one
-						 * data comamnd
+						 * data command 
 						 */
 
 #define SBSDIO_CORE_ADDR_MASK		0x1FFFF	/* sdio core function one address mask */
-- 
1.6.5.GIT

