Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab0IIWYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:24:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38003 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab0IIWYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SEPnme/5luT/wbJdzUdfQJGAxRUhqrZ8MBEQ0CE+8tA7eDjFTwbbM6jsgAD3ZFSdDs
         iT0jeLlOLKXlaPZy9hv+vizCVJ+I1t+qCXvcnrxAiDcZoXjlltdc450RulCILy0wAEpY
         F2n+YTMjErO3p4FKXeAX96j1KPHIQq4YJY0/s=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 002/223]drivers/atm/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:24:38 -0700
Message-Id: <1284071091-7676-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
References: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/atm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/Kconfig b/drivers/atm/Kconfig
index be7461c..a01f6b2 100644
--- a/drivers/atm/Kconfig
+++ b/drivers/atm/Kconfig
@@ -301,7 +301,7 @@ config ATM_IA
 	  control memory (128K-1KVC, 512K-4KVC), the size of the packet
 	  memory (128K, 512K, 1M), and the PHY type (Single/Multi mode OC3,
 	  UTP155, UTP25, DS3 and E3). Go to:
-	  	<http://www.iphase.com/products/ClassSheet.cfm?ClassID=ATM>
+	  	<http://www.iphase.com/products/whitepapers/>
 	  for more info about the cards. Say Y (or M to compile as a module
 	  named iphase) here if you have one of these cards.
 
-- 
1.7.2.1

