Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1KVMHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:07:07 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:33291 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1KVMHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:07:06 -0500
Message-ID: <1321963622.18752.1.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] sound: Kconfig: drop unknown symbol ARCH_CLPS7500
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 22 Nov 2011 13:07:02 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 635f0258e5 ("[ARM] clps7500: remove support") missed one instance
of the ARCH_CLPS7500 Kconfig symbol. Drop it now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 sound/oss/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index 6c9e8e8..5849b12 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -521,7 +521,7 @@ config SC6600_CDROMBASE
 
 config SOUND_VIDC
 	tristate "VIDC 16-bit sound"
-	depends on ARM && (ARCH_ACORN || ARCH_CLPS7500)
+	depends on ARM && ARCH_ACORN
 	help
 	  16-bit support for the VIDC onboard sound hardware found on Acorn
 	  machines.
-- 
1.7.7.3



