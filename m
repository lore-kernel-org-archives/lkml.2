Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab2J2Rvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:51:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63180 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab2J2Rvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:51:48 -0400
Date: Mon, 29 Oct 2012 18:51:38 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>
Cc: lm-sensors@lm-sensors.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        oprofile-list@lists.sf.net, Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, Borislav Petkov <bp@alien8.de>,
        =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
Subject: [PATCH 2/4] x86, microcode_amd: Change email addresses, MAINTAINERS
 entry
Message-ID: <20121029175138.GC5024@tweety>
References: <20121029174924.GA5024@tweety>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029174924.GA5024@tweety>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
---
 MAINTAINERS                     |    4 ++--
 arch/x86/kernel/microcode_amd.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a4e8136..5a66583 100644
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
-- 
1.7.9.5

