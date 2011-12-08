Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1LHXSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:18:14 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:24516 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545Ab1LHXSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:18:11 -0500
From: Vinson Lee <vlee@vmware.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vlee@vmware.com, trivial@kernel.org
Subject: [PATCH] devices.txt: Fix typo of 'VMware'.
Date: Thu,  8 Dec 2011 15:18:02 -0800
Message-Id: <1323386282-3545-1-git-send-email-vlee@vmware.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinson Lee <vlee@vmware.com>
---
 Documentation/devices.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index eccffe7..cec8864 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -379,7 +379,7 @@ Your cooperation is appreciated.
 		162 = /dev/smbus	System Management Bus
 		163 = /dev/lik		Logitech Internet Keyboard
 		164 = /dev/ipmo		Intel Intelligent Platform Management
-		165 = /dev/vmmon	VMWare virtual machine monitor
+		165 = /dev/vmmon	VMware virtual machine monitor
 		166 = /dev/i2o/ctl	I2O configuration manager
 		167 = /dev/specialix_sxctl Specialix serial control
 		168 = /dev/tcldrv	Technology Concepts serial control
-- 
1.7.1

