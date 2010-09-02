Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab0IBVG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:06:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39302 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0IBVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DJTSaGajj+6hBejsoLN73VoB/1LpVeX4IplVqhDji3Lzhaj00NcwgHAbjh3VIbBo/B
         Y612RsFry7QNyw4BHF4bIT8+l+aSvx9ldT/6K+P+2god+8KV4CDOmdPYOvZsPsgT5lQc
         frZw2F7ImmHxnagUj+1Emu5aNQhAXaY2G9Gts=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 07/91] arch/arm/common/icst.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:38 -0700
Message-Id: <1283461606-7803-8-git-send-email-justinmattock@gmail.com>
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
 arch/arm/common/icst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/icst.c b/arch/arm/common/icst.c
index 9a7f09c..2dc6da70 100644
--- a/arch/arm/common/icst.c
+++ b/arch/arm/common/icst.c
@@ -8,7 +8,7 @@
  * published by the Free Software Foundation.
  *
  *  Support functions for calculating clocks/divisors for the ICST307
- *  clock generators.  See http://www.icst.com/ for more information
+ *  clock generators.  See http://www.idt.com/ for more information
  *  on these devices.
  *
  *  This is an almost identical implementation to the ICST525 clock generator.
-- 
1.7.2.1

