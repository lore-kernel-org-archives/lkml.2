Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965514Ab2JWVBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:01:25 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48812 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933710Ab2JWUFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:14 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jiri Pirko <jpirko@redhat.com>
Subject: [PATCH 097/193] drivers/net/team: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:50 -0700
Message-Id: <1351022666-6960-98-git-send-email-keescook@chromium.org>
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

CC: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/team/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/team/Kconfig b/drivers/net/team/Kconfig
index 6b08bd4..c3011af 100644
--- a/drivers/net/team/Kconfig
+++ b/drivers/net/team/Kconfig
@@ -1,6 +1,5 @@
 menuconfig NET_TEAM
-	tristate "Ethernet team driver support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Ethernet team driver support"
 	---help---
 	  This allows one to create virtual interfaces that teams together
 	  multiple ethernet devices.
-- 
1.7.9.5

