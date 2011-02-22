Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1BVVhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:37:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:40056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab1BVVhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:37:17 -0500
Date: Tue, 22 Feb 2011 21:36:58 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
In-Reply-To: <4D5D3309020000780003264A@vpn.id2.novell.com>
References: <4D5D3309020000780003264A@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Streamline kernel/irq/Kconfig
Message-ID: <tip-fd4afaf33313d94f548cb09129ecba3dbab62931@git.kernel.org>
Git-Commit-ID: fd4afaf33313d94f548cb09129ecba3dbab62931
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 22 Feb 2011 21:36:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd4afaf33313d94f548cb09129ecba3dbab62931
Gitweb:     http://git.kernel.org/tip/fd4afaf33313d94f548cb09129ecba3dbab62931
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 17 Feb 2011 13:39:05 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 22 Feb 2011 22:33:10 +0100

genirq: Streamline kernel/irq/Kconfig

"def_bool n" without prompt is pointless, these should be just "bool".

[ tglx: Adapted to latest changes ]

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4D5D3309020000780003264A@vpn.id2.novell.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/irq/Kconfig |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 9149be7..355b8c7 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -1,5 +1,5 @@
 config HAVE_GENERIC_HARDIRQS
-	def_bool n
+	bool
 
 if HAVE_GENERIC_HARDIRQS
 menu "IRQ subsystem"
@@ -11,32 +11,32 @@ config GENERIC_HARDIRQS
 
 # Select this to disable the deprecated stuff
 config GENERIC_HARDIRQS_NO_DEPRECATED
-       def_bool n
+       bool
 
 config GENERIC_HARDIRQS_NO_COMPAT
-       def_bool n
+       bool
 
 # Options selectable by the architecture code
 config HAVE_SPARSE_IRQ
-       def_bool n
+       bool
 
 config GENERIC_IRQ_PROBE
-	def_bool n
+	bool
 
 config GENERIC_IRQ_SHOW
-       def_bool n
+       bool
 
 config GENERIC_PENDING_IRQ
-	def_bool n
+	bool
 
 config AUTO_IRQ_AFFINITY
-       def_bool n
+       bool
 
 config HARDIRQS_SW_RESEND
-       def_bool n
+       bool
 
 config IRQ_PREFLOW_FASTEOI
-       def_bool n
+       bool
 
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
