Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1KQShO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:37:14 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:58906 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1KQShK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:37:10 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/platform: (TS-5500) fix CONFIG_TS5500_ADC dependency
Date: Thu, 17 Nov 2011 13:36:52 -0500
Message-Id: <1321555012-14331-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's the fix for the Kconfig dependency issue, for the TS-5500 platform.
It is based on the latest x86/platform branch from the -tip tree.

Best,

    Vivien

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 arch/x86/platform/ts5500/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/ts5500/Kconfig b/arch/x86/platform/ts5500/Kconfig
index be51b86..84e59a9 100644
--- a/arch/x86/platform/ts5500/Kconfig
+++ b/arch/x86/platform/ts5500/Kconfig
@@ -23,6 +23,6 @@ config TS5500_LED
 
 config TS5500_ADC
 	bool "TS-5500 ADC"
-	depends on TS5500
+	depends on TS5500 && HWMON=y
 	help
       Support for the A/D converter on Technologic Systems TS-5500 SBCs.
-- 
1.7.6.4

