Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2HDHSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 03:18:16 -0400
Received: from mail-pb0-f66.google.com ([209.85.160.66]:53447 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2HDHSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 03:18:13 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>,
        =?UTF-8?q?Mikko=20Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        =?UTF-8?q?Riku=20Mett=C3=A4l=C3=A4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Subject: =?UTF-8?q?=5BPATCH=204/5=5D=20staging/csr=3A=20remove=20the=20initialisation=20of=20interfaceTag=20and=20its=20comment=20in=20handle=5Fbh=5Ferror?=
Date: Sat,  4 Aug 2012 13:03:05 +0545
Message-Id: <1344064685-12337-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the interfaceTag is actually initialised in for loop of this function
and its not needed to initialise it before for loop.

and also remove the comment that is obvious about this variable.

Cc: Mikko Virkkilä <mikko.virkkila@bluegiga.com>
Cc: Lauri Hintsala <Lauri.Hintsala@bluegiga.com>
Cc: Riku Mettälä <riku.mettala@bluegiga.com>
Cc: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/csr/bh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/csr/bh.c b/drivers/staging/csr/bh.c
index 2597e22..3193df2 100644
--- a/drivers/staging/csr/bh.c
+++ b/drivers/staging/csr/bh.c
@@ -164,7 +164,7 @@ uf_wait_for_thread_to_stop(unifi_priv_t *priv, struct uf_thread *thread)
 handle_bh_error(unifi_priv_t *priv)
 {
     u8 conf_param = CONFIG_IND_ERROR;
-    u8 interfaceTag = 0; /* used as a loop counter */
+    u8 interfaceTag;
 
 
     /* Block unifi_run_bh() until the error has been handled. */
-- 
1.7.9.5

