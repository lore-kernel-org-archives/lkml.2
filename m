Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab0IIWg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:36:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab0IIWgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aok16se0sFyamtrtsb1RQktmjHu5Hbigc0NenJ5ukNM4gP0BarNkRrqhMs1o40nWqW
         IJrl2ODtJUgYb6DWDLDk0rBPzg3G9ej4K1Vs8pdVONbOBpLoWpqIRS20+uroZMDMyJU9
         K8PvYlVfCGdpngQ11yH9agzylwYf/hh/A/bDU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 106/223]drivers/net/irda/donauboe.h Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:35 -0700
Message-Id: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/irda/donauboe.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/donauboe.h b/drivers/net/irda/donauboe.h
index 36c3060..9e9a82d 100644
--- a/drivers/net/irda/donauboe.h
+++ b/drivers/net/irda/donauboe.h
@@ -54,7 +54,7 @@
 /* anyone who has. HOWEVER the chip bears a striking resemblence */
 /* to the IrDA controller in the Toshiba RISC TMPR3922 chip      */
 /* the documentation for this is freely available at             */
-/* http://www.toshiba.com/taec/components/Generic/TMPR3922.shtml */
+/* http://www.toshiba.com/tai/					 */
 /* The mapping between the registers in that document and the    */
 /* Registers in the 701 oboe chip are as follows    */
 
-- 
1.7.2.1

