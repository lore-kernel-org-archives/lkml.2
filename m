Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab0F1Ly4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:54:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab0F1Lyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KEyuoefoZQaIDkKZVyroqdF/tN5oQ13VbeLITd+XKNXacbI9mPxd+N1z40PkQsXnkh
         hj1EgMfGzE2/iwvUVoATMq0yJIbuYDfWancVjrPPlQim4KjdStxHzHfdOrhUSsl+3N2z
         nYWWZ/DOxMtc5QJYHE0XSOAwgTVg2gkiA2l+E=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Kulikov Vasiliy <segooon@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Fulghum <paulkf@microgate.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:54:48 +0400
Message-Id: <1277726089-24467-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/synclink_gt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 4561ce2..334cf5c 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -4845,7 +4845,7 @@ static int register_test(struct slgt_info *info)
 {
 	static unsigned short patterns[] =
 		{0x0000, 0xffff, 0xaaaa, 0x5555, 0x6969, 0x9696};
-	static unsigned int count = sizeof(patterns)/sizeof(patterns[0]);
+	static unsigned int count = ARRAY_SIZE(patterns);
 	unsigned int i;
 	int rc = 0;
 
-- 
1.7.0.4

