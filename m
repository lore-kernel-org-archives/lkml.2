Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab1KQKlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:41:37 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:34204 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab1KQKlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:41:36 -0500
Subject: [PATCH] [TRIVIAL] x86: Kconfig: drop unknown symbol 'APM_MODULE'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 11:41:31 +0100
Message-ID: <1321526491.20271.275.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no Kconfig symbol APM_MODULE, so the check for it will always
fail. There's no need to append _MODULE to tristate symbols anyhow,
because the config tools will do the right thing automagically.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Added in commit a6b68076fd ("x86: compile apm and voyager module only
when selected in Kconfig"). The reason for appending _MODULE can be
found at https://lkml.org/lkml/2008/1/3/422 .

 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb9a104..e4d218e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1726,7 +1726,7 @@ source "drivers/sfi/Kconfig"
 
 config X86_APM_BOOT
 	def_bool y
-	depends on APM || APM_MODULE
+	depends on APM
 
 menuconfig APM
 	tristate "APM (Advanced Power Management) BIOS support"
-- 
1.7.4.4

