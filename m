Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0IBVJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:09:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab0IBVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:09:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Kb0CSebezgeA+X9ZClJiA04pI6IHWi8AiZlhtgR0ggOpYKc5ofNPPLNJJUAuKhqnL6
         MR+dbWPfpH/EF/61bZZehh0MktTj12nSgtZF7Nram3MDKB9QzuUh8FYxDlv7tYjcMNo7
         EFnIRq/yJmfQ4M2p4MQEPUa+DDx1vRIdfmMEA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 38/91] arch/m68k/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:08:59 -0700
Message-Id: <1283461746-7905-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
References: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/m68k/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 8030e24..b092426 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -221,7 +221,7 @@ config SUN3X
 	  Be warned that this support is very experimental.
 	  Note that Sun 3x kernels are not compatible with Sun 3 hardware.
 	  General Linux information on the Sun 3x series (now discontinued)
-	  is at <http://www.angelfire.com/ca2/tech68k/sun3.html>.
+	  is at <http://web.archive.org/web/*/angelfire.com/ca2/tech68k/sun3.html>.
 
 	  If you don't want to compile a kernel for a Sun 3x, say N.
 
-- 
1.7.2.1

