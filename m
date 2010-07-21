Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab0GUFFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:05:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:33149 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762315Ab0GUE6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XeTfYyE14U+9Kr0uAKhMifvdbYzVkEy8Bm22TJzxVNpg/9H91o4ljpeXzdOQDnbmAF
         XHImoztTVh+TXFbnHq6uNkg5j87EOmU1CVs1UR2fclqJh4ilBaawhCgtGDOx/JVbjJoN
         NLZFwH+l9OidrjHPBefPc1BlpETxfntAqCFqs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 118/118]Documentation/usb/linux.inf update web address.
Date: Tue, 20 Jul 2010 21:57:57 -0700
Message-Id: <1279688279-29683-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/usb/linux.inf |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/usb/linux.inf b/Documentation/usb/linux.inf
index 2f7217d..af71d87 100644
--- a/Documentation/usb/linux.inf
+++ b/Documentation/usb/linux.inf
@@ -9,7 +9,7 @@
 ;
 ; Microsoft only directly supports RNDIS drivers, and bundled them into XP.
 ; The Microsoft "Remote NDIS USB Driver Kit" is currently found at:
-;   http://www.microsoft.com/whdc/hwdev/resources/HWservices/rndis.mspx
+;   http://www.microsoft.com/whdc/device/network/ndis/rmndis.mspx
 
 
 [Version]
-- 
1.7.1.rc1.21.gf3bd6

