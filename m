Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024Ab2JWULY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:11:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37864 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934002Ab2JWULO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:11:14 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 178/193] net/nfc/nci: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:11 -0700
Message-Id: <1351022666-6960-179-git-send-email-keescook@chromium.org>
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

CC: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
CC: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/nfc/nci/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/Kconfig b/net/nfc/nci/Kconfig
index decdc49..6d69b5f 100644
--- a/net/nfc/nci/Kconfig
+++ b/net/nfc/nci/Kconfig
@@ -1,6 +1,6 @@
 config NFC_NCI
-	depends on NFC && EXPERIMENTAL
-	tristate "NCI protocol support (EXPERIMENTAL)"
+	depends on NFC
+	tristate "NCI protocol support"
 	default n
 	help
 	  NCI (NFC Controller Interface) is a communication protocol between
-- 
1.7.9.5

