Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965390Ab2JWUzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:55:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41156 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933586Ab2JWUFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:19 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 116/193] drivers/ptp: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:09 -0700
Message-Id: <1351022666-6960-117-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/ptp/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index ffdf712..a6e4b7c 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -9,7 +9,6 @@ comment "Enable Device Drivers -> PPS to see the PTP clock options."
 
 config PTP_1588_CLOCK
 	tristate "PTP clock support"
-	depends on EXPERIMENTAL
 	depends on PPS
 	help
 	  The IEEE 1588 standard defines a method to precisely
-- 
1.7.9.5

