Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1FZVFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:05:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59337 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab1FZVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hKh7n/A7b7mFO0i4rqk5izLnfJ9oha0SpwUMUUzc6W7CD3s+5tM+k8Saki4NIClpPi
         /N4qtJUEAc/WSleQHhPQ7UuynUbz5Uzv4gpI/43ao3/yUFm3YmoQSWvbUzl5ZbRSx9vd
         RbUGe3kJtjVyxCK4h7oeEG2izMc3IkeeS9IcA=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mtd/ofpart: add ofoldpart alias
Date: Mon, 27 Jun 2011 01:03:00 +0400
Message-Id: <1309122180-12838-3-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
References: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ofpart.ko also provides ofoldpart MTD parser. Add respective
MODULE_ALIAS("ofoldpart"); declaration.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/mtd/ofpart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
index aa33b8a..c4b8d17 100644
--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -176,3 +176,4 @@ module_init(ofpart_parser_init);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Parser for MTD partitioning information in device tree");
 MODULE_AUTHOR("Vitaly Wool, David Gibson");
+MODULE_ALIAS("ofoldpart");
-- 
1.7.5.4

