Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0IBVGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:06:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39302 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0IBVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Mi/Lz2davjPrDsE4Q/19rdNVKnC7pqQni6b0oPByP2hE/eUqdjvTPPx+AlyoXzS++m
         0orTOBEA14fvwcGPMuMMdg2b0F3PghWcBRyTNiruX+D4tubgTXY0w2Jma9fMKsfmOHMY
         JUm3Qow+q9NK/+fTY6df3FXCEvJTW2LGFDsT4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 06/91] arch/arm/mach-sa1100/cpu-sa1100.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:37 -0700
Message-Id: <1283461606-7803-7-git-send-email-justinmattock@gmail.com>
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
 arch/arm/mach-sa1100/cpu-sa1100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-sa1100/cpu-sa1100.c b/arch/arm/mach-sa1100/cpu-sa1100.c
index ef81787..c0a13ef 100644
--- a/arch/arm/mach-sa1100/cpu-sa1100.c
+++ b/arch/arm/mach-sa1100/cpu-sa1100.c
@@ -13,7 +13,7 @@
  * This software has been developed while working on the LART
  * computing board (http://www.lartmaker.nl/), which is
  * sponsored by the Mobile Multi-media Communications
- * (http://www.mmc.tudelft.nl/) and Ubiquitous Communications
+ * (http://www.mobimedia.org/) and Ubiquitous Communications
  * (http://www.ubicom.tudelft.nl/) projects.
  *
  * The authors can be reached at:
-- 
1.7.2.1

