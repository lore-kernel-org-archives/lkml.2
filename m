Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1IVOP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:15:28 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:13420 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1IVOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:15:23 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjDEQEiPVxA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH 1/2] xen/pv-on-hvm kexec: update xs_wire.h:xsd_sockmsg_type from xen-unstable
Date: Thu, 22 Sep 2011 16:14:48 +0200
Message-Id: <1316700889-3518-2-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316700889-3518-1-git-send-email-olaf@aepfle.de>
References: <1316700889-3518-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update include/xen/interface/io/xs_wire.h from xen-unstable.
Now entries in xsd_sockmsg_type were added.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 include/xen/interface/io/xs_wire.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/xen/interface/io/xs_wire.h b/include/xen/interface/io/xs_wire.h
index 99fcffb..f6f07aa 100644
--- a/include/xen/interface/io/xs_wire.h
+++ b/include/xen/interface/io/xs_wire.h
@@ -26,7 +26,10 @@ enum xsd_sockmsg_type
     XS_SET_PERMS,
     XS_WATCH_EVENT,
     XS_ERROR,
-    XS_IS_DOMAIN_INTRODUCED
+    XS_IS_DOMAIN_INTRODUCED,
+    XS_RESUME,
+    XS_SET_TARGET,
+    XS_RESTRICT
 };
 
 #define XS_WRITE_NONE "NONE"
-- 
1.7.3.4

