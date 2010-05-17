Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0EQRHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:07:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49194 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab0EQRHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:07:10 -0400
Date: Mon, 17 May 2010 17:06:52 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, tglx@linutronix.de
In-Reply-To: <20100517164324.GB10254@alberich.amd.com>
References: <20100517164324.GB10254@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/timers] x86, hpet: Add reference to chipset erratum documentation for disable-hpet-msi-quirk
Message-ID: <tip-fec84e330719c20d2146c8dbdc9ff50b3a1d7039@git.kernel.org>
Git-Commit-ID: fec84e330719c20d2146c8dbdc9ff50b3a1d7039
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 17 May 2010 17:06:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fec84e330719c20d2146c8dbdc9ff50b3a1d7039
Gitweb:     http://git.kernel.org/tip/fec84e330719c20d2146c8dbdc9ff50b3a1d7039
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Mon, 17 May 2010 18:43:24 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 17 May 2010 10:04:43 -0700

x86, hpet: Add reference to chipset erratum documentation for disable-hpet-msi-quirk

(At the moment the "SB700 Family Product Errata" document is available
at http://support.amd.com/us/Embedded_TechDocs/46837.pdf)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100517164324.GB10254@alberich.amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/quirks.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index cd2c336..e72d3fc 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -495,6 +495,9 @@ void force_hpet_resume(void)
 /*
  * HPET MSI on some boards (ATI SB700/SB800) has side effect on
  * floppy DMA. Disable HPET MSI on such platforms.
+ * See erratum #27 (Misinterpreted MSI Requests May Result in
+ * Corrupted LPC DMA Data) in AMD Publication #46837,
+ * "SB700 Family Product Errata", Rev. 1.0, March 2010.
  *
  * Also force the read back of the CMP register in hpet_next_event()
  * to work around the problem that the CMP register write seems to be
