Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0IIXId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:08:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41812 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab0IIW02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UEtZk/GXWRM7m7n51lCgZQjLzdwAS8xdXbvemWtpR+y2UybNoiAMI8Y5bXHzuXEfCQ
         mwUJZdQixrA3A4XlMrvi0FBeMt9Q7kFrLjnQassvFLFZIjIK3I1GxtDjtNosJ4tMCKyB
         laNZLsUyg4/TecUwbM48vkiU96NMElGAvekMs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 033/223]drivers/infiniband/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:26:33 -0700
Message-Id: <1284071205-7756-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/infiniband/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 89d70de..cf769f1 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -16,7 +16,7 @@ config INFINIBAND_USER_MAD
 	  Userspace InfiniBand Management Datagram (MAD) support.  This
 	  is the kernel side of the userspace MAD support, which allows
 	  userspace processes to send and receive MADs. You will also
-	  need libibumad from <http://www.openib.org>.
+	  need libibumad from <http://openfabrics.org/>.
 
 config INFINIBAND_USER_ACCESS
 	tristate "InfiniBand userspace access (verbs and CM)"
@@ -28,7 +28,7 @@ config INFINIBAND_USER_ACCESS
 	  to set up connections and directly access InfiniBand
 	  hardware for fast-path operations.  You will also need
 	  libibverbs, libibcm and a hardware driver library from
-	  <http://www.openib.org>.
+	  <git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git>.
 
 config INFINIBAND_USER_MEM
 	bool
-- 
1.7.2.1

