Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab2JZMcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:32:16 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:46761 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2JZMcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:32:10 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 4/4] arm: mvebu: adding SATA support: dt binding for Armada 370/XP boards
Date: Fri, 26 Oct 2012 14:30:49 +0200
Message-Id: <1351254650-26861-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351254650-26861-1-git-send-email-gregory.clement@free-electrons.com>
References: <1351254650-26861-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the SATA device tree bindings for
- Armada XP evaluation board (DB-78460-BP)
- Armada 370 evaluation board (DB-88F6710-BP-DDR3)

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Lior Amsalem <alior@marvell.com>
---
 arch/arm/boot/dts/armada-370-db.dts |    4 ++++
 arch/arm/boot/dts/armada-xp-db.dts  |    4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370-db.dts b/arch/arm/boot/dts/armada-370-db.dts
index 4a31b03..060e5ba 100644
--- a/arch/arm/boot/dts/armada-370-db.dts
+++ b/arch/arm/boot/dts/armada-370-db.dts
@@ -34,5 +34,9 @@
 			clock-frequency = <200000000>;
 			status = "okay";
 		};
+		sata@d00a0000 {
+                        nr-ports = <2>;
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/armada-xp-db.dts b/arch/arm/boot/dts/armada-xp-db.dts
index b1fc728..375436b 100644
--- a/arch/arm/boot/dts/armada-xp-db.dts
+++ b/arch/arm/boot/dts/armada-xp-db.dts
@@ -46,5 +46,9 @@
 			clock-frequency = <250000000>;
 			status = "okay";
 		};
+		sata@d00a0000 {
+                        nr-ports = <2>;
+			status = "okay";
+		};
 	};
 };
-- 
1.7.9.5

