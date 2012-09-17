Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2IQQwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:52:11 -0400
Received: from mail.x86-64.org ([217.9.48.20]:53942 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab2IQQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:52:09 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] x86, mce: Enable MCA support by default
Date: Mon, 17 Sep 2012 18:52:02 +0200
Message-Id: <1347900723-17490-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1347900723-17490-1-git-send-email-bp@amd64.org>
References: <1347900723-17490-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

MCA is the basic support for hardware error logging and reporting, and
it is majorly unwise to run without it so enable machine check software
support by default on x86.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1aa4abd..3d2d2ef0e16a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -871,6 +871,7 @@ config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 
 config X86_MCE
 	bool "Machine Check / overheating reporting"
+	default y
 	---help---
 	  Machine Check support allows the processor to notify the
 	  kernel if it detects a problem (e.g. overheating, data corruption).
-- 
1.7.11.rc1

