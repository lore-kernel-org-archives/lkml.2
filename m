Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2EGJAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:00:44 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:3639 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779Ab2EGJAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:00:43 -0400
Message-ID: <1336381237.1933.19.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] c2port: fix Kconfig typo "default no"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 11:00:37 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 07 May 2012 09:00:37.0687 (UTC) FILETIME=[DECFFC70:01CD2C2F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strictly speaking "no" is a valid, but undefined, Kconfig symbol. But what
obviously was meant here was "n".

While we're touching this Kconfig file also drop the superfluous
dependency on C2PORT for C2PORT_DURAMAR_2150. Its Kconfig entry is
already wrapped in "if C2PORT" and "endif".

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/misc/c2port/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/c2port/Kconfig b/drivers/misc/c2port/Kconfig
index e46af9a..33ee834 100644
--- a/drivers/misc/c2port/Kconfig
+++ b/drivers/misc/c2port/Kconfig
@@ -5,7 +5,7 @@
 menuconfig C2PORT
 	tristate "Silicon Labs C2 port support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	default no
+	default n
 	help
 	  This option enables support for Silicon Labs C2 port used to
 	  program Silicon micro controller chips (and other 8051 compatible).
@@ -23,8 +23,8 @@ if C2PORT
 
 config C2PORT_DURAMAR_2150
 	tristate "C2 port support for Eurotech's Duramar 2150 (EXPERIMENTAL)"
-	depends on X86 && C2PORT
-	default no
+	depends on X86
+	default n
 	help
 	  This option enables C2 support for the Eurotech's Duramar 2150
 	  on board micro controller.
-- 
1.7.7.6



