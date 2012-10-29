Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351Ab2J2WDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:03:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:47830 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761334Ab2J2Vhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Wu <josh.wu@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [ 073/101] ARM: at91/tc: fix typo in the DT document
Date: Mon, 29 Oct 2012 14:35:26 -0700
Message-Id: <20121029213248.401149996@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Wu <josh.wu@atmel.com>

commit 11930c530f3edf81160e4962e363d579f5cdce7e upstream.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/arm/atmel-at91.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


