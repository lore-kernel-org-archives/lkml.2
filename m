Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab2CBAzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:55:25 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419Ab2CBAzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:55:24 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/5] OpenRISC: Select GENERIC_ATOMIC64
Date: Fri,  2 Mar 2012 01:55:11 +0100
Message-Id: <1330649715-32438-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To have atomit64_t on OpenRISC we need GENERIC_ATOMIC64.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index bc428b5..a478719 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -16,6 +16,7 @@ config OPENRISC
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
 	select GENERIC_CPU_DEVICES
+	select GENERIC_ATOMIC64
 
 config MMU
 	def_bool y
-- 
1.7.7.3

