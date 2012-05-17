Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762315Ab2EQSNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:13:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35625 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab2EQSNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:13:47 -0400
Date: Thu, 17 May 2012 11:13:34 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-2ee93ab67a73955018dff6ad76916e20a2ba10f7@git.kernel.org>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, lenb@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mjg@redhat.com, lenb@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1336597442-9399-1-git-send-email-hpa@linux.intel.com>
References: <1336597442-9399-1-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] acpi, bgrd: Add missing <linux/io.h>
  to drivers/acpi/bgrt.c
Git-Commit-ID: 2ee93ab67a73955018dff6ad76916e20a2ba10f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 17 May 2012 11:13:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ee93ab67a73955018dff6ad76916e20a2ba10f7
Gitweb:     http://git.kernel.org/tip/2ee93ab67a73955018dff6ad76916e20a2ba10f7
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 9 May 2012 14:04:02 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 17 May 2012 07:18:26 -0700

acpi, bgrd: Add missing <linux/io.h> to drivers/acpi/bgrt.c

The ACPI BGRT driver uses ioremap() and memcpy_fromio(), which means
it needs to #include <linux/io.h>.

[ hpa: This was hidden because <asm/acpi.h> used to include <asm/trampoline.h>,
  which then included <asm/io.h> ]

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1336597442-9399-1-git-send-email-hpa@linux.intel.com
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/bgrt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index 8cf6c46..6680df3 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
+#include <linux/io.h>
 #include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>
 
