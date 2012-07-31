Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab2GaUOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:14:12 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53847 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221Ab2GaUOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:14:09 -0400
Date: Tue, 31 Jul 2012 14:49:34 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: Add a MAINTAINERS entry for P7+ in-Nest crypto driver
Message-ID: <20120731194931.GA23426@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073120-9360-0000-0000-000008F4FC8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a MAINTAINERS entry for the IBM Power in-Nest Crypto Acceleators
driver.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb036a0..757fe60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3414,6 +3414,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
 S:	Maintained
 F:	arch/ia64/
 
+IBM Power in-Nest Crypto Acceleration
+M:	Kent Yoder <key@linux.vnet.ibm.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/crypto/nx/
+
 IBM Power Linux RAID adapter
 M:	Brian King <brking@us.ibm.com>
 S:	Supported
-- 
1.7.5.4

