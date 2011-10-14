Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab1JNM3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:29:36 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58229 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab1JNM3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:29:34 -0400
Subject: [PATCH 09/21] samples: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:28:38 +0200
Message-ID: <1318595318.6132.66.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 samples/Kconfig |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 96a7572..41063e7 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -61,10 +61,4 @@ config SAMPLE_KDB
 	  Build an example of how to dynamically add the hello
 	  command to the kdb shell.
 
-config SAMPLE_HIDRAW
-	bool "Build simple hidraw example"
-	depends on HIDRAW && HEADERS_CHECK
-	help
-	  Build an example of how to use hidraw from userspace.
-
 endif # SAMPLES
-- 
1.7.4.4




