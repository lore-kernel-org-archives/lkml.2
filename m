Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab1BYGLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:11:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34432 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1BYGLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:11:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uBwa98ne9md5llDIAwgWEarNr7p/yUhYlRrQpwiKU5+tqHJstqGJaJWd12vOhsM2nW
         moQz0x+Ktn/gZB75+jM87ZdiKM1vAuFZW6XFtvxSuomY3lD1KiREorv7ZUwIzre5KXod
         2ET0QSfOL+gSUUpfabjQQdkAgecZfHK2u5aYM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: ipslinux@adaptec.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/21]drivers:scsi:ips.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:10:58 -0800
Message-Id: <1298614258-3610-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/ips.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index b2511ac..ece1445 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -4494,7 +4494,7 @@ ips_init_scb(ips_ha_t * ha, ips_scb_t * scb)
 /*                                                                          */
 /*   Initialize a CCB to default values                                     */
 /*                                                                          */
-/* ASSUMED to be callled from within a lock                                 */
+/* ASSUMED to be called from within a lock                                 */
 /*                                                                          */
 /****************************************************************************/
 static ips_scb_t *
-- 
1.7.4.1

