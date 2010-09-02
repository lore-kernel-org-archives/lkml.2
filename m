Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab0IBVKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:10:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab0IBVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HG4J7AM5VfnsTEP916OEfDKM3o6wACa7HK8mN8x06UcPBRYr6ImB5AyjEbKlinvW5L
         uj4A4sQef7Z+rPw/FNaCqjJAZaS8KReAd72xq/DFrDO34X9KZZxHfcINEoHtnzMKA/m/
         R5A5yyxIZcPOLZUWO7S2RKyrr68grvFTYPldU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 51/91] arch/mips/math-emu/cp1emu.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:10:15 -0700
Message-Id: <1283461824-7943-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461824-7943-1-git-send-email-justinmattock@gmail.com>
References: <1283461824-7943-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/mips/math-emu/cp1emu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index 47842b7..11326c7 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -3,7 +3,7 @@
  *
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * Kevin D. Kissell, kevink@mips.com and Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2000  MIPS Technologies, Inc.
-- 
1.7.2.1

