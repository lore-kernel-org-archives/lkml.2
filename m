Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2GQK4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:56:18 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:55790 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753969Ab2GQK4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:56:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAPlDBVBbdWOb/2dsb2JhbABFhWqzZYEHgiEBBSMPATQSECUCJgICVwYTiBGpXJMSgSCPVYESA5U9kAiCYQ
X-IronPort-AV: E=Sophos;i="4.77,601,1336341600"; 
   d="scan'208";a="1020350049"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net
Subject: [PATCH 2/2] Staging: ipack: change naming convention in TODO file
Date: Tue, 17 Jul 2012 12:56:18 +0200
Message-Id: <1342522578-24046-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342522578-24046-1-git-send-email-siglesias@igalia.com>
References: <1342522578-24046-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the ANSI/VITA 4.0-1995 (S2011) naming convention for the mezzanine or
daughter boards. They are called IP modules in the Standard.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/TODO |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ipack/TODO b/drivers/staging/ipack/TODO
index 25ed7ae..b21d33a 100644
--- a/drivers/staging/ipack/TODO
+++ b/drivers/staging/ipack/TODO
@@ -3,7 +3,7 @@
 Introduction
 ============
 
-These drivers add support for IndustryPack devices: carrier and mezzanine
+These drivers add support for IndustryPack devices: carrier and IP module
 boards.
 
 The ipack driver is just an abstraction of the bus providing the common
@@ -31,7 +31,7 @@ Ipack
 -----
 
 * The structures and API exported can be improved a lot. For example, the
-  way to unregistering mezzanine devices, doing the mezzanine driver a call to
+  way to unregistering IP module devices, doing the IP module driver a call to
   remove_device() to notify the carrier driver, or the opposite with the call to
   the ipack_driver_ops' remove() function could be improved.
 
-- 
1.7.10.4

