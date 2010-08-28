Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0H1LHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 07:07:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34000 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0H1LHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 07:07:18 -0400
Date: Sat, 28 Aug 2010 13:07:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andres Salomon <dilinger@collabora.co.uk>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] misc devices: Do not enable by default
Message-ID: <20100828110712.GA25785@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Frysinger <vapier@gentoo.org>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Andres Salomon <dilinger@collabora.co.uk>,
	Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not enable this Kconfig menu by default since it contains devices not
present on the majority of systems.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---

This is becoming a pain and a waste of time especially when doing a
bunch of kernel builds on different systems daily and have to answer
"make oldconfig" prompts for strange devices.

 drivers/misc/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0b591b6..08909f6 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig MISC_DEVICES
 	bool "Misc devices"
-	default y
 	---help---
 	  Say Y here to get to see options for device drivers from various
 	  different categories. This option alone does not add any kernel code.
-- 
1.7.1


-- 
Regards/Gruss,
    Boris.
