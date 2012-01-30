Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2A3WMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:12:07 -0500
Received: from [206.117.179.246] ([206.117.179.246]:38390 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752860Ab2A3WME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:12:04 -0500
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [RFC PATCH] telephony: Move to staging
Date: Mon, 30 Jan 2012 14:11:34 -0800
Message-Id: <cd8d3ef8b646dc0b1c451e61c57d639cadbc7c21.1327961290.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stuff is really old and in quite poor shape.
Does anyone still use it?

If not, I think it's appropriate to let it simmer
in staging for a few releases.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/Kconfig                              |    2 --
 drivers/staging/Kconfig                      |    2 ++
 drivers/{ => staging}/telephony/Kconfig      |    0
 drivers/{ => staging}/telephony/Makefile     |    0
 drivers/{ => staging}/telephony/ixj-ver.h    |    0
 drivers/{ => staging}/telephony/ixj.c        |    0
 drivers/{ => staging}/telephony/ixj.h        |    0
 drivers/{ => staging}/telephony/ixj_pcmcia.c |    0
 drivers/{ => staging}/telephony/phonedev.c   |    0
 9 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/{ => staging}/telephony/Kconfig (100%)
 rename drivers/{ => staging}/telephony/Makefile (100%)
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
index 21e2f4b..7364c41 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -132,4 +132,6 @@ source "drivers/staging/omapdrm/Kconfig"
 
 source "drivers/staging/android/Kconfig"
 
+source "drivers/telephony/Kconfig"
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

