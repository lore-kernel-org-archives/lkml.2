Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2KSFbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:05 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59197 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KSFbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:02 -0500
X-Originating-IP: 217.70.178.143
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, Ram Pai <linuxram@us.ibm.com>,
        T Makphaibulchoke <tmac@hp.com>, Wei Yang <weiyang@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 32/58] kernel/resource.c: Include linux/mm.h for page_is_ram prototype
Date: Sun, 18 Nov 2012 21:28:11 -0800
Message-Id: <1353302917-13995-33-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C files should include the header files that prototype their functions.
This keeps the types in sync, and eliminates warnings from GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/resource.c:365:27: warning: no previous prototype for ‘page_is_ram’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/resource.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/resource.c b/kernel/resource.c
index 73f35d4..f593f18 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -21,6 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/device.h>
 #include <linux/pfn.h>
+#include <linux/mm.h>
 #include <asm/io.h>
 
 
-- 
1.7.10.4

