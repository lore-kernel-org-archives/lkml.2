Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0CVJ72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 05:59:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab0CVJ71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 05:59:27 -0400
Date: Mon, 22 Mar 2010 05:59:23 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Amerigo Wang <amwang@redhat.com>,
       David Miller <davem@davemloft.net>
Message-Id: <20100322100305.5518.29500.sendpatchset@localhost.localdomain>
Subject: [Patch] netconsole: do not depend on experimental
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nowadays, most distributions enable netconsole by default,
including RHEL, Fedora, Debian, Arch, Opensuse. And
we don't have any bug reports about it. So I think there
is no need to mark it as experimental any more.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 0ba5b8e..e3d6c52 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3252,15 +3252,14 @@ config NET_FC
 	  "SCSI generic support".
 
 config NETCONSOLE
-	tristate "Network console logging support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Network console logging support"
 	---help---
 	If you want to log kernel messages over the network, enable this.
 	See <file:Documentation/networking/netconsole.txt> for details.
 
 config NETCONSOLE_DYNAMIC
-	bool "Dynamic reconfiguration of logging targets (EXPERIMENTAL)"
-	depends on NETCONSOLE && SYSFS && EXPERIMENTAL
+	bool "Dynamic reconfiguration of logging targets"
+	depends on NETCONSOLE && SYSFS
 	select CONFIGFS_FS
 	help
 	  This option enables the ability to dynamically reconfigure target
