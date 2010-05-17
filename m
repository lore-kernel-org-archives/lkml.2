Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0EQW4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:56:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57929 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab0EQW4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:56:41 -0400
Date: Tue, 18 May 2010 00:56:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/doc change for v2.6.35
Message-ID: <20100517225630.GA773@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-doc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-doc-for-linus

 Thanks,

	Ingo

------------------>
Randy Dunlap (1):
      x86, docbook: Fix errors from x86 headers merger


 Documentation/DocBook/device-drivers.tmpl |    2 +-
 Documentation/DocBook/deviceiobook.tmpl   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index f9a6e2c..1b2dd4f 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -45,7 +45,7 @@
      </sect1>
 
      <sect1><title>Atomic and pointer manipulation</title>
-!Iarch/x86/include/asm/atomic_32.h
+!Iarch/x86/include/asm/atomic.h
 !Iarch/x86/include/asm/unaligned.h
      </sect1>
 
diff --git a/Documentation/DocBook/deviceiobook.tmpl b/Documentation/DocBook/deviceiobook.tmpl
index 3ed8812..c1ed6a4 100644
--- a/Documentation/DocBook/deviceiobook.tmpl
+++ b/Documentation/DocBook/deviceiobook.tmpl
@@ -316,7 +316,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_lock, flags)
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Iarch/x86/include/asm/io_32.h
+!Iarch/x86/include/asm/io.h
 !Elib/iomap.c
   </chapter>
 
