Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1BYGPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:15:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39555 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1BYGPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:15:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XVZEP/f1u6oBAo3vL8BNxMWwbZeFhcLB2isJZgX+Qm0Wh19QDx0cfwtjkFkx3zXdrp
         4/liZ8LxQnMYBL/92sRQmNUui2+llhVQ2KMgfV0JTfEXYU6TZ5c06t9CrTeDawxQhxMe
         lpJWWO4pbCkAgobWQgxRyFXvqOUIKFUzM3NJM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 17/21]fs:cifs:connect.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:15:02 -0800
Message-Id: <1298614502-4114-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8d6c17a..ea4a146 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -722,7 +722,7 @@ multi_t2_fnd:
 		sock_release(csocket);
 		server->ssocket = NULL;
 	}
-	/* buffer usuallly freed in free_mid - need to free it here on exit */
+	/* buffer usually freed in free_mid - need to free it here on exit */
 	cifs_buf_release(bigbuf);
 	if (smallbuf) /* no sense logging a debug message if NULL */
 		cifs_small_buf_release(smallbuf);
-- 
1.7.4.1

