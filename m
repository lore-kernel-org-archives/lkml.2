Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab2EKIUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:20:51 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:42035 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab2EKISb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:18:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKjKrE9bdWOb/2dsb2JhbABEtB6BB4IWAQVnEhBRVwYTiBK7DJE0BJV9kECCa4Fd
X-IronPort-AV: E=Sophos;i="4.75,570,1330902000"; 
   d="scan'208";a="513690772"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] Staging: ipack: add contact email in TODO file
Date: Fri, 11 May 2012 10:17:12 +0200
Message-Id: <1336724236-21665-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
References: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added myself in the TODO file.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/TODO |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/ipack/TODO b/drivers/staging/ipack/TODO
index 11828ed..3a45a53 100644
--- a/drivers/staging/ipack/TODO
+++ b/drivers/staging/ipack/TODO
@@ -38,3 +38,9 @@ Ipack
   way to unregistering mezzanine devices, doing the mezzanine driver a call to
   remove_device() to notify the carrier driver, or the opposite with the call to
   the ipack_driver_ops' remove() function could be improved.
+
+
+Contact
+=======
+
+Contact: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
\ No newline at end of file
-- 
1.7.10

