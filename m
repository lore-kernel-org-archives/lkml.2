Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab0GUFCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:02:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52687 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547Ab0GUE7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ShIFXdMwLMbrE12tFwcpL4N0M/FV1U4jfKThhYYEiwNTXvSm3wm0X8cQRV4cQMgabb
         76zuW/EUpjD4vviG4JWJrhp2ajdOdRKahuz0yu4tXLdUnj/3VeEYWibP7wazq5/IrxLs
         G0v6Fv9P07DnUkGNAaT1/q9Gi1rM0rDRSYSlM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 129/129]Documentation/video4linux/bttv/Specs update web address.
Date: Tue, 20 Jul 2010 21:58:46 -0700
Message-Id: <1279688336-29735-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/bttv/Specs |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/video4linux/bttv/Specs b/Documentation/video4linux/bttv/Specs
index 79b9e57..f32466c 100644
--- a/Documentation/video4linux/bttv/Specs
+++ b/Documentation/video4linux/bttv/Specs
@@ -1,3 +1,3 @@
 Philips		http://www.Semiconductors.COM/pip/
-Conexant	http://www.conexant.com/techinfo/default.asp
-Micronas	http://www.micronas.de/pages/product_documentation/index.html
+Conexant	http://www.conexant.com/
+Micronas	http://www.micronas.com/en/home/index.html
-- 
1.7.1.rc1.21.gf3bd6

