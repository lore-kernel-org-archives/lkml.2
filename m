Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab2J3MWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:22:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2J3MW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:22:29 -0400
Date: Tue, 30 Oct 2012 05:21:44 -0700
From: tip-bot for Andreas Herrmann <herrmann.der.user@googlemail.com>
Message-ID: <tip-943482d07e926128eed0482b879736f912c429e4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, joro@8bytes.org, bp@alien8.de, linux@roeck-us.net,
        khali@linux-fr.org, herrmann.der.user@googlemail.com,
        tglx@linutronix.de, rjw@sisk.pl, rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org, bp@alien8.de,
        linux@roeck-us.net, khali@linux-fr.org,
        herrmann.der.user@googlemail.com, tglx@linutronix.de, rjw@sisk.pl,
        rric@kernel.org
In-Reply-To: <20121029175138.GC5024@tweety>
References: <20121029175138.GC5024@tweety>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode_amd: Change email addresses,
  MAINTAINERS entry
Git-Commit-ID: 943482d07e926128eed0482b879736f912c429e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:21:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  943482d07e926128eed0482b879736f912c429e4
Gitweb:     http://git.kernel.org/tip/943482d07e926128eed0482b879736f912c429e4
Author:     Andreas Herrmann <herrmann.der.user@googlemail.com>
AuthorDate: Mon, 29 Oct 2012 18:51:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Oct 2012 10:05:52 +0100

x86, microcode_amd: Change email addresses, MAINTAINERS entry

Signed-off-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: lm-sensors@lm-sensors.org
Cc: oprofile-list@lists.sf.net
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jorg Roedel <joro@8bytes.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Link: http://lkml.kernel.org/r/20121029175138.GC5024@tweety
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 MAINTAINERS                     |    4 ++--
 arch/x86/kernel/microcode_amd.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e775b87..1740370 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -534,9 +534,9 @@ F:	drivers/iommu/amd_iommu*.[ch]
 F:	include/linux/amd-iommu.h
 
 AMD MICROCODE UPDATE SUPPORT
-M:	Andreas Herrmann <andreas.herrmann3@amd.com>
+M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
 L:	amd64-microcode@amd64.org
-S:	Supported
+S:	Maintained
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7720ff5..b3e67ba 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -8,8 +8,8 @@
  *  Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
  *
  *  Maintainers:
- *  Andreas Herrmann <andreas.herrmann3@amd.com>
- *  Borislav Petkov <borislav.petkov@amd.com>
+ *  Andreas Herrmann <herrmann.der.user@googlemail.com>
+ *  Borislav Petkov <bp@alien8.de>
  *
  *  This driver allows to upgrade microcode on F10h AMD
  *  CPUs and later.
