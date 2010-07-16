Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab0GPUYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:24:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57990 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab0GPUYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:24:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 16 Jul 2010 22:24:29 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] firewire: core: use C99 initializer in array of ioctl
 handlers
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
Message-ID: <tkrat.a0bf8facd7fc567f@s5r6.in-berlin.de>
References: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to make the correspondence of ioctl numbers and handlers more obvious.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   42 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1386,27 +1386,27 @@ static int ioctl_send_stream_packet(stru
 }
 
 static int (* const ioctl_handlers[])(struct client *, union ioctl_arg *) = {
-	ioctl_get_info,
-	ioctl_send_request,
-	ioctl_allocate,
-	ioctl_deallocate,
-	ioctl_send_response,
-	ioctl_initiate_bus_reset,
-	ioctl_add_descriptor,
-	ioctl_remove_descriptor,
-	ioctl_create_iso_context,
-	ioctl_queue_iso,
-	ioctl_start_iso,
-	ioctl_stop_iso,
-	ioctl_get_cycle_timer,
-	ioctl_allocate_iso_resource,
-	ioctl_deallocate_iso_resource,
-	ioctl_allocate_iso_resource_once,
-	ioctl_deallocate_iso_resource_once,
-	ioctl_get_speed,
-	ioctl_send_broadcast_request,
-	ioctl_send_stream_packet,
-	ioctl_get_cycle_timer2,
+	[0x00] = ioctl_get_info,
+	[0x01] = ioctl_send_request,
+	[0x02] = ioctl_allocate,
+	[0x03] = ioctl_deallocate,
+	[0x04] = ioctl_send_response,
+	[0x05] = ioctl_initiate_bus_reset,
+	[0x06] = ioctl_add_descriptor,
+	[0x07] = ioctl_remove_descriptor,
+	[0x08] = ioctl_create_iso_context,
+	[0x09] = ioctl_queue_iso,
+	[0x0a] = ioctl_start_iso,
+	[0x0b] = ioctl_stop_iso,
+	[0x0c] = ioctl_get_cycle_timer,
+	[0x0d] = ioctl_allocate_iso_resource,
+	[0x0e] = ioctl_deallocate_iso_resource,
+	[0x0f] = ioctl_allocate_iso_resource_once,
+	[0x10] = ioctl_deallocate_iso_resource_once,
+	[0x11] = ioctl_get_speed,
+	[0x12] = ioctl_send_broadcast_request,
+	[0x13] = ioctl_send_stream_packet,
+	[0x14] = ioctl_get_cycle_timer2,
 };
 
 static int dispatch_ioctl(struct client *client,

-- 
Stefan Richter
-=====-==-=- -=== =----
http://arcgraph.de/sr/

