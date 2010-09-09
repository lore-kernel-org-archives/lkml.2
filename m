Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab0IIWgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:36:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab0IIWg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Au9yRob7i00aUWo05kZlFE7oiBY3dgGRdHMwY3DUqynNmE4HdXpFYPQmoGeFBbdjQt
         oSuyLoO9CgS/RxY7AXNZTmhoB0uvDQgDBXbFSV2BgZYlCTtgTRR/vUHY71aeg2IMo3Ph
         9CfPNEy6z9ds7UsiWm4AQsTN/UX4dGIyOSzRw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 108/223]drivers/net/yellowfin.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:37 -0700
Message-Id: <1284071809-8149-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
References: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/yellowfin.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/yellowfin.c b/drivers/net/yellowfin.c
index 4eb67ae..2900193 100644
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@ -198,8 +198,7 @@ IVb. References
 Yellowfin Engineering Design Specification, 4/23/97 Preliminary/Confidential
 Symbios SYM53C885 PCI-SCSI/Fast Ethernet Multifunction Controller Preliminary
    Data Manual v3.0
-http://cesdis.gsfc.nasa.gov/linux/misc/NWay.html
-http://cesdis.gsfc.nasa.gov/linux/misc/100mbps.html
+http://www.beowulf.org/
 
 IVc. Errata
 
-- 
1.7.2.1

