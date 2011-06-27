Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab1F0MgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 08:36:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55696 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab1F0MfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 08:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KMjUn97jqx6yPtvxHn9l0rBUb48NGDpyuXxmN+1H2iKQWl/MokYainwXI0dgEHQLDI
         9k9t4JAp5s0b8dWHAFRS2HS9TW9Nc6iDzi+LWcaFUV55GAo1FHMn3wbQKC5Ad2d5XGhu
         /eZdQrT8kI2p9Rn/2fcqgue0/DCLVNETyAUdE=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mtd/ofpart: add ofoldpart alias
Date: Mon, 27 Jun 2011 16:34:46 +0400
Message-Id: <1309178086-10604-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309154611.23597.18.camel@sauron>
References: <1309154611.23597.18.camel@sauron>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ofpart.ko also provides ofoldpart MTD parser. Add respective
MODULE_ALIAS("ofoldpart"); declaration.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/mtd/ofpart.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
index aa33b8a..77f0640 100644
--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -176,3 +176,6 @@ module_init(ofpart_parser_init);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Parser for MTD partitioning information in device tree");
 MODULE_AUTHOR("Vitaly Wool, David Gibson");
+/* Required so that this module will be picked up ofoldpart
+ * MTD partition information parser */
+MODULE_ALIAS("ofoldpart");
-- 
1.7.5.4

