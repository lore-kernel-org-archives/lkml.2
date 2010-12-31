Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0LaRig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:38:36 -0500
Received: from mail-pv0-f194.google.com ([74.125.83.194]:34117 "EHLO
	mail-pv0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0LaRid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ue7bxWX0Di8ai6Whx3aryrxJz7Vjfxx0cLuECdl6FS2A0dYt5uENkhdf8reuaoE/xD
         kyGRQxCuhGT/xKBw4LslTQGHQepD1T/B6zc72Uif+SJJrLZYQfY50dx8UWZBUP9O2Ufx
         T3K1IrVYySSTGlGH6QZGkA2TmyFWeXX+PNnYQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/7] net/sungem.h Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:38:44 -0800
Message-Id: <1293817124-7980-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/sungem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sungem.h b/drivers/net/sungem.h
index 1990546..bfb6683 100644
--- a/drivers/net/sungem.h
+++ b/drivers/net/sungem.h
@@ -843,7 +843,7 @@ struct gem_txd {
 
 /* GEM requires that RX descriptors are provided four at a time,
  * aligned.  Also, the RX ring may not wrap around.  This means that
- * there will be at least 4 unused desciptor entries in the middle
+ * there will be at least 4 unused descriptor entries in the middle
  * of the RX ring at all times.
  *
  * Similar to HME, GEM assumes that it can write garbage bytes before
-- 
1.6.5.2.180.gc5b3e

