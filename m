Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab2FQR5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:57:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36511 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab2FQR5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:57:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 17 Jun 2012 19:57:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: core: document is_local sysfs attribute
Message-ID: <20120617195723.067510d5@stein>
In-Reply-To: <20120617195617.372a35c5@stein>
References: <4FDDEC64.5080004@ladisch.de>
	<20120617195617.372a35c5@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/ABI/stable/sysfs-bus-firewire |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/ABI/stable/sysfs-bus-firewire
+++ b/Documentation/ABI/stable/sysfs-bus-firewire
@@ -39,6 +39,17 @@ Users:		udev rules to set ownership and
 		/dev/fw[0-9]+ character device files
 
 
+What:		/sys/bus/firewire/devices/fw[0-9]+/is_local
+Date:		July 2012
+KernelVersion:	3.6
+Contact:	linux1394-devel@lists.sourceforge.net
+Description:
+		IEEE 1394 node device attribute.
+		Read-only and immutable.
+Values:		1: The sysfs entry represents a local node (a controller card).
+		0: The sysfs entry represents a remote node.
+
+
 What:		/sys/bus/firewire/devices/fw[0-9]+[.][0-9]+/
 Date:		May 2007
 KernelVersion:	2.6.22



-- 
Stefan Richter
-=====-===-- -==- =---=
http://arcgraph.de/sr/
