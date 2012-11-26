Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981Ab2KZROK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:14:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab2KZROG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Wu <josh.wu@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 227/270] ARM: at91/tc: fix typo in the DT document
Date: Mon, 26 Nov 2012 14:58:37 -0200
Message-Id: <1353949160-26803-228-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Wu <josh.wu@atmel.com>

commit 11930c530f3edf81160e4962e363d579f5cdce7e upstream.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 .../devicetree/bindings/arm/atmel-at91.txt         |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
index ecc81e3..d187e9f 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
@@ -8,7 +8,7 @@ PIT Timer required properties:
   shared across all System Controller members.
 
 TC/TCLIB Timer required properties:
-- compatible: Should be "atmel,<chip>-pit".
+- compatible: Should be "atmel,<chip>-tcb".
   <chip> can be "at91rm9200" or "at91sam9x5"
 - reg: Should contain registers location and length
 - interrupts: Should contain all interrupts for the TC block
-- 
1.7.9.5

