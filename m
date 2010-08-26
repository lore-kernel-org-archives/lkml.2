Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0HZW3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 18:29:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46112 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab0HZW3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 18:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tLa5uZy8GBgwwsjgEE+wnIIW/3zM/evfyP5oCc81NJ7LbVmZbgoCdBj4Sf0O8Mf5G+
         zr2veXSJCMQD8wRCxv1FeZI9fMvLg0zx3O0Q5N631H6Ofx2lEItHXDNVvG10SHMoOoex
         xwVUG80WB2xBNGozwoDGf8x9wTNWIrUmjLcPA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]MAINTAINERS update broken web address.
Date: Thu, 26 Aug 2010 15:30:03 -0700
Message-Id: <1282861803-17641-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address in the MAINTAINERS
file. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 11e34d5..e4dff75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3289,7 +3289,7 @@ F:	scripts/package/
 
 KERNEL JANITORS
 L:	kernel-janitors@vger.kernel.org
-W:	http://janitor.kernelnewbies.org/
+W:	http://kernelnewbies.org/KernelJanitors
 S:	Odd Fixes
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
-- 
1.7.1.rc1.21.gf3bd6

