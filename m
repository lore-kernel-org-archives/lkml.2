Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462Ab2JWVBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:01:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45389 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933713Ab2JWUFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:14 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH 076/193] drivers/net: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:29 -0700
Message-Id: <1351022666-6960-77-git-send-email-keescook@chromium.org>
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

CC: "David S. Miller" <davem@davemloft.net>
CC: Stephen Hemminger <shemminger@vyatta.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Mike Sterling <Mike.Sterling@microsoft.com>
CC: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/Kconfig |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 6a70184..2334190 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -123,8 +123,7 @@ config IFB
 source "drivers/net/team/Kconfig"
 
 config MACVLAN
-	tristate "MAC-VLAN support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "MAC-VLAN support"
 	---help---
 	  This allows one to create virtual interfaces that map packets to
 	  or from specific MAC addresses to a particular interface.
@@ -138,7 +137,7 @@ config MACVLAN
 	  will be called macvlan.
 
 config MACVTAP
-	tristate "MAC-VLAN based tap driver (EXPERIMENTAL)"
+	tristate "MAC-VLAN based tap driver"
 	depends on MACVLAN
 	help
 	  This adds a specialized tap character device driver that is based
@@ -234,8 +233,8 @@ config VETH
 	  versa.
 
 config VIRTIO_NET
-	tristate "Virtio network driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && VIRTIO
+	tristate "Virtio network driver"
+	depends on VIRTIO
 	---help---
 	  This is the virtual network driver for virtio.  It can be used with
 	  lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
-- 
1.7.9.5

