Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934951Ab2JXPeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:34:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11061 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933942Ab2JXPeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:14 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <voice.shen@atmel.com>,
        <marek.belisko@open-nandra.com>, <ivan.shugov@gmail.com>,
        <josh.wu@atmel.com>
Subject: [PATCH 1/8] ARM: at91/tc: fix typo in the DT document
Date: Wed, 24 Oct 2012 17:33:50 +0200
Message-ID: <bc543c9d3af88b9f09cd5514efc893c6f0fa459b.1351092432.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <cover.1351092432.git.nicolas.ferre@atmel.com>
References: <cover.1351092432.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Wu <josh.wu@atmel.com>

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> [v3.4]
---
 Documentation/devicetree/bindings/arm/atmel-at91.txt | 2 +-
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
1.7.11.3

