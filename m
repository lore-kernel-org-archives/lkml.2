Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab0IIW0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:26:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41812 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab0IIW0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BMLBanPX1SEukZyp2CxzC/0VO2gQHXv3WgQagPQrrQ81fv1tVxolNPD2g8pneDQR1X
         1H1FyMVkUtnzwobB3Pt//S0tTYZCffQvWJsRRCKGbCGGJo2ZtLf2EGQFlzSVVBe1+p2O
         h6sNjIPReTLjMcP8cSn8eBgutUmVFT6j+IRJE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 042/223]drivers/media/IR/keymaps/rc-rc5-tv.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:26:42 -0700
Message-Id: <1284071205-7756-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/IR/keymaps/rc-rc5-tv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/keymaps/rc-rc5-tv.c b/drivers/media/IR/keymaps/rc-rc5-tv.c
index 73cce2f..61be0bd 100644
--- a/drivers/media/IR/keymaps/rc-rc5-tv.c
+++ b/drivers/media/IR/keymaps/rc-rc5-tv.c
@@ -13,7 +13,7 @@
 #include <media/rc-map.h>
 
 /* generic RC5 keytable                                          */
-/* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
+/* see http://web.archive.org/web/*/http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
 /* used by old (black) Hauppauge remotes                         */
 
 static struct ir_scancode rc5_tv[] = {
-- 
1.7.2.1

