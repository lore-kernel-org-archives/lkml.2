Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0F3NiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:38:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab0F3NiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:38:10 -0400
From: Jes.Sorensen@redhat.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mdr@sgi.com
Subject: [PATCH] Add mdr as maintainer of qla1280 driver.
Date: Wed, 30 Jun 2010 15:37:38 +0200
Message-Id: <1277905058-14236-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <Jes.Sorensen@redhat.com>

As discussed with Mike Reed, add him as the maintainer of the qla1280
driver as I no longer have any hardware and he is actively looking
after it.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6c73b3b..612301c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4628,6 +4628,12 @@ M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	rtc-linux@googlegroups.com
 S:	Maintained
 
+QLOGIC QLA1280 SCSI DRIVER
+M:	Michael Reed <mdr@sgi.com>
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	drivers/scsi/qla1280.[ch]
+
 QLOGIC QLA2XXX FC-SCSI DRIVER
 M:	Andrew Vasquez <andrew.vasquez@qlogic.com>
 M:	linux-driver@qlogic.com
-- 
1.7.0.1

