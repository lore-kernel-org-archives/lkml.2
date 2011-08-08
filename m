Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1HHNad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:30:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44250 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662Ab1HHNac convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:30:32 -0400
Subject: [PATCH] headers, ncp: Add missing #include to <linux/ncp_fs.h> for
 userland
From: Ben Hutchings <ben@decadent.org.uk>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 08 Aug 2011 14:30:29 +0100
Message-ID: <1312810229.2591.1154.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/ncp_fs.h> uses size_t, defined for userland by <stddef.h>.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ncp_fs.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
index e13eefe..e220c8a 100644
--- a/include/linux/ncp_fs.h
+++ b/include/linux/ncp_fs.h
@@ -16,6 +16,10 @@
 #include <linux/ipx.h>
 #include <linux/ncp_no.h>
 
+#ifndef __KERNEL__
+#include <stddef.h>
+#endif
+
 /*
  * ioctl commands
  */
-- 
1.7.5.4


