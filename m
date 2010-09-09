Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab0IIWhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:37:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50159 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab0IIWh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fkgehm7v+SRDnQzESwC1jLDW80S3CwXgcP6uOm6/RGZ2d3QAc9BwNJJOnq8j3Twcs7
         ZeOrr0uHwM+uTu4gEFWQ0NSEdzUTvMMHv79eDtToqzhayaqnoq5pc4z4mJeSIwVqdW2X
         JRcVZngDNJSPdRD+1TGTQT5FCCEHY7mE7oIb8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 125/223]drivers/pcmcia/yenta_socket.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:32 -0700
Message-Id: <1284071862-8194-5-git-send-email-justinmattock@gmail.com>
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
 drivers/pcmcia/yenta_socket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 414d9a6..91a7225 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1073,7 +1073,7 @@ static void yenta_config_init(struct yenta_socket *socket)
  * invisible during PCI scans because of a misconfigured subordinate number
  * of the parent brige - some BIOSes seem to be too lazy to set it right.
  * Does the fixup carefully by checking how far it can go without conflicts.
- * See http\://bugzilla.kernel.org/show_bug.cgi?id=2944 for more information.
+ * See http://bugzilla.kernel.org/show_bug.cgi?id=2944 for more information.
  */
 static void yenta_fixup_parent_bridge(struct pci_bus *cardbus_bridge)
 {
-- 
1.7.2.1

