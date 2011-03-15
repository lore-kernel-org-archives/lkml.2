Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab1COXLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:11:46 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51083 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754883Ab1COXLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:11:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=A6Nk0tzWvYZJZ3RbW0gIfZBFQ9tyvBQ5aECff5GIfx9ecl9jSLNJWTWSR4DzhMJzM4BiTD5ugPYQzl64Vqn1irrX1YLO94Q1MEJ6OfKgOcLg/JOd8ScI76zB3c3Fu++K;
Date: Tue, 15 Mar 2011 16:11:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Rob Landley <rlandley@parallels.com>, grant.likely@secretlab.ca
Subject: [PATCH 2/6] Documentation: add devicetree docs index file
Message-Id: <20110315161141.238991ab.rdunlap@xenotime.net>
In-Reply-To: <20110315134316.465b6e2c.rdunlap@xenotime.net>
References: <20110315134316.465b6e2c.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>

The device tree infrastructure is being genericized so its documentation moved
out of the PowerPC directory.

Signed-off-by: Rob Landley <rlandley@parallels.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 Documentation/devicetree/00-INDEX |   10 ++++++++++
 Documentation/powerpc/00-INDEX    |    4 ----
 2 files changed, 10 insertions(+), 4 deletions(-)

--- /dev/null
+++ lnx-2638-rc8/Documentation/devicetree/00-INDEX
@@ -0,0 +1,10 @@
+Documentation for device trees, a data structure by which bootloaders pass
+hardware layout to Linux in a device-independent manner, simplifying hardware
+probing.  This subsystem is maintained by Grant Likely
+<grant.likely@secretlab.ca> and has a mailing list at
+https://lists.ozlabs.org/listinfo/devicetree-discuss
+
+00-INDEX
+	- this file
+booting-without-of.txt
+	- Booting Linux without Open Firmware, describes history and format of device trees.
--- lnx-2638-rc8.orig/Documentation/powerpc/00-INDEX
+++ lnx-2638-rc8/Documentation/powerpc/00-INDEX
@@ -5,8 +5,6 @@ please mail me.
 
 00-INDEX
 	- this file
-booting-without-of.txt
-	- Booting the Linux/ppc kernel without Open Firmware
 cpu_features.txt
 	- info on how we support a variety of CPUs with minimal compile-time
 	options.
@@ -16,8 +14,6 @@ hvcs.txt
 	- IBM "Hypervisor Virtual Console Server" Installation Guide
 mpc52xx.txt
 	- Linux 2.6.x on MPC52xx family
-mpc52xx-device-tree-bindings.txt
-	- MPC5200 Device Tree Bindings
 sound.txt
 	- info on sound support under Linux/PPC
 zImage_layout.txt
