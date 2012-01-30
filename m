Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab2A3WzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:55:11 -0500
Received: from [206.117.179.246] ([206.117.179.246]:37186 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752051Ab2A3WzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:55:09 -0500
Message-ID: <1327964088.25132.65.camel@joe2Laptop>
Subject: [RFC PATCH V2] telephony: Move to staging
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Date: Mon, 30 Jan 2012 14:54:48 -0800
In-Reply-To: <20120130221838.GA5904@suse.de>
References: <cd8d3ef8b646dc0b1c451e61c57d639cadbc7c21.1327961290.git.joe@perches.com>
	 <20120130221838.GA5904@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stuff is really old and in quite poor shape.
Does anyone still use it?

If not, I think it's appropriate to let it simmer
in staging for a few releases.

Signed-off-by: Joe Perches <joe@perches.com>
---
Changes since V1:
Added TODO
Corrected telephony path in drivers/staging/Kconfig so make works

 drivers/Kconfig                              |    2 --
 drivers/staging/Kconfig                      |    2 ++
 drivers/{ => staging}/telephony/Kconfig      |    0
 drivers/{ => staging}/telephony/Makefile     |    0
 drivers/staging/telephony/TODO               |   10 ++++++++++
 drivers/{ => staging}/telephony/ixj-ver.h    |    0
 drivers/{ => staging}/telephony/ixj.c        |    0
 drivers/{ => staging}/telephony/ixj.h        |    0
 drivers/{ => staging}/telephony/ixj_pcmcia.c |    0
 drivers/{ => staging}/telephony/phonedev.c   |    0
 10 files changed, 12 insertions(+), 2 deletions(-)
 rename drivers/{ => staging}/telephony/Kconfig (100%)
 rename drivers/{ => staging}/telephony/Makefile (100%)
 create mode 100644 drivers/staging/telephony/TODO
 rename drivers/{ => staging}/telephony/ixj-ver.h (100%)
 rename drivers/{ => staging}/telephony/ixj.c (100%)
 rename drivers/{ => staging}/telephony/ixj.h (100%)
 rename drivers/{ => staging}/telephony/ixj_pcmcia.c (100%)
 rename drivers/{ => staging}/telephony/phonedev.c (100%)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index d5138e6..2272307 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -40,8 +40,6 @@ source "drivers/net/Kconfig"
 
 source "drivers/isdn/Kconfig"
 
-source "drivers/telephony/Kconfig"
-
 # input before char - char/joystick depends on it. As does USB.
 
 source "drivers/input/Kconfig"
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 21e2f4b..aaba36c 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -132,4 +132,6 @@ source "drivers/staging/omapdrm/Kconfig"
 
 source "drivers/staging/android/Kconfig"
 
+source "drivers/staging/telephony/Kconfig"
+
 endif # STAGING
diff --git a/drivers/telephony/Kconfig b/drivers/staging/telephony/Kconfig
similarity index 100%
rename from drivers/telephony/Kconfig
rename to drivers/staging/telephony/Kconfig
diff --git a/drivers/telephony/Makefile b/drivers/staging/telephony/Makefile
similarity index 100%
rename from drivers/telephony/Makefile
rename to drivers/staging/telephony/Makefile
diff --git a/drivers/staging/telephony/TODO b/drivers/staging/telephony/TODO
new file mode 100644
index 0000000..d47dec3
--- /dev/null
+++ b/drivers/staging/telephony/TODO
@@ -0,0 +1,10 @@
+TODO
+. Determine if the boards are still in use
+  and move this module back to drivers/telephony if necessary
+. Coding style cleanups
+
+Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
+cc Joe Perches <joe@perches.com> if the module should be reactivated.
+
+If no module activity occurs before version 3.6 is released, this
+module should be removed.
diff --git a/drivers/telephony/ixj-ver.h b/drivers/staging/telephony/ixj-ver.h
similarity index 100%
rename from drivers/telephony/ixj-ver.h
rename to drivers/staging/telephony/ixj-ver.h
diff --git a/drivers/telephony/ixj.c b/drivers/staging/telephony/ixj.c
similarity index 100%
rename from drivers/telephony/ixj.c
rename to drivers/staging/telephony/ixj.c
diff --git a/drivers/telephony/ixj.h b/drivers/staging/telephony/ixj.h
similarity index 100%
rename from drivers/telephony/ixj.h
rename to drivers/staging/telephony/ixj.h
diff --git a/drivers/telephony/ixj_pcmcia.c b/drivers/staging/telephony/ixj_pcmcia.c
similarity index 100%
rename from drivers/telephony/ixj_pcmcia.c
rename to drivers/staging/telephony/ixj_pcmcia.c
diff --git a/drivers/telephony/phonedev.c b/drivers/staging/telephony/phonedev.c
similarity index 100%
rename from drivers/telephony/phonedev.c
rename to drivers/staging/telephony/phonedev.c
-- 
1.7.8.111.gad25c.dirty



