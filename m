Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0IBVHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:07:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53806 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab0IBVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jFetWcg8rYuIIsP+NAi96Wg7j7om9dU+TdPqLvA5iziRiExOx4/2y92KmAgRX01wq3
         xRZupVLmJDnndnROUYqH8QXyCGhOwuDbzwxUZzc4hlauw5NJ/vmHzmzSztAKZ/UQwIlF
         aVdzjZCQrsl+Czt8GTb43SDXtvkttysi3y1pQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 02/91] arch/alpha/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:33 -0700
Message-Id: <1283461606-7803-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/alpha/Kconfig |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index b9647bb..16ae162 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -219,7 +219,8 @@ config ALPHA_LX164
 	bool "LX164"
 	help
 	  A technical overview of this board is available at
-	  <http://www.unix-ag.org/Linux-Alpha/Architectures/LX164.html>.
+	  <http://web.archive.org/web/*/http://www.unix-ag.org/
+	  Linux-Alpha/Architectures/LX164.html>.
 
 config ALPHA_LYNX
 	bool "Lynx"
@@ -483,7 +484,8 @@ config ALPHA_AVANTI
 	help
 	  Avanti AS 200, AS 205, AS 250, AS 255, AS 300, and AS 400-based
 	  Alphas. Info at
-	  <http://www.unix-ag.org/Linux-Alpha/Architectures/Avanti.html>.
+	  <http://web.archive.org/web/*/http://www.unix-ag.org/Linux-Alpha/
+	  Architectures/Avanti.html>.
 
 config ALPHA_BROKEN_IRQ_MASK
 	bool
-- 
1.7.2.1

