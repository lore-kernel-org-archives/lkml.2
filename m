Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2JOR07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:26:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34587 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2JOR04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:26:56 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 13/14] staging: csr: Encapsulated (parenthesis'd) complex macro value on io.c
Date: Tue, 16 Oct 2012 02:25:35 +0900
Message-Id: <1350321936-2664-4-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321936-2664-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321936-2664-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made correction on the definition of a macro using parenthesis.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index f910aea..74c891a 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -878,7 +878,7 @@ static int
 uf_read_proc(char *page, char **start, off_t offset, int count,
 		int *eof, void *data)
 {
-#define UNIFI_DEBUG_TXT_BUFFER 8*1024
+#define UNIFI_DEBUG_TXT_BUFFER (8*1024)
 	unifi_priv_t *priv;
 	int actual_amount_to_copy;
 	char *p, *orig_p;
-- 
1.7.9.5

