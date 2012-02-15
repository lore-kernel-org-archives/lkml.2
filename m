Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab2BORT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:19:28 -0500
Received: from hulk.biessmann.org ([62.75.166.25]:54028 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2BORT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:19:27 -0500
X-Greylist: delayed 1759 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Feb 2012 12:19:27 EST
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Michal Marek <mmarek@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
Subject: [PATCH] x86, build: remove unused include
Date: Wed, 15 Feb 2012 17:49:49 +0100
Message-Id: <1329324589-26907-1-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.9
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: 0345b8340adb562460864a31bd608314
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 079f85e624189292d1c818b47764916bf8cf84a8 removed necessity for
sys/sysmacros.h include but missed to remove the include.

Still requiring sys/sysmacros.h for build tool breaks cross compiling x86 kernel
on non linux style systems which may not offer sys/sysmacros.h.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
---
 arch/x86/boot/tools/build.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 4e9bd6b..52628cd 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -29,7 +29,6 @@
 #include <stdarg.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/sysmacros.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/mman.h>
-- 
1.7.9

