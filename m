Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab1JEEne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 00:43:34 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32253 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004Ab1JEEnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 00:43:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwBACbdi06WZd+d/2dsb2JhbAAMNoRtlFKRU1Y1AiYCcq1IkUGBLYRjgRMEpT8
Subject: [PATCH 1/4] atm: solos-pci: Add AnnexA/M capability attributes
From: Nathan Williams <nathan@traverse.com.au>
To: netdev@vger.kernel.org
Cc: linux-atm-general@lists.sourceforge.net,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 15:43:30 +1100
Message-ID: <1317789810.2424.82.camel@dualcore.traverse>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BisACapability and BisMCapability allow users to
force either Annex A or Annex M.

Signed-off-by: Nathan Williams <nathan@traverse.com.au>
---
 drivers/atm/solos-attrlist.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/atm/solos-attrlist.c b/drivers/atm/solos-attrlist.c
index 9a676ee..8092533 100644
--- a/drivers/atm/solos-attrlist.c
+++ b/drivers/atm/solos-attrlist.c
@@ -71,6 +71,8 @@ SOLOS_ATTR_RW(BisAForceSNRMarginDn)
 SOLOS_ATTR_RW(BisMForceSNRMarginDn)
 SOLOS_ATTR_RW(BisAMaxMargin)
 SOLOS_ATTR_RW(BisMMaxMargin)
+SOLOS_ATTR_RW(BisACapability)
+SOLOS_ATTR_RW(BisMCapability)
 SOLOS_ATTR_RW(AnnexAForceSNRMarginDn)
 SOLOS_ATTR_RW(AnnexAMaxMargin)
 SOLOS_ATTR_RW(AnnexMMaxMargin)
-- 
1.7.2.5



