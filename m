Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0DOQDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:03:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45971 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab0DOQDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:03:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 15 Apr 2010 18:02:19 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [git pull] FireWire fixes and documentation update
To: linux-kernel@vger.kernel.org
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.66ea5df34ac46da2@s5r6.in-berlin.de>
Message-ID: <tkrat.fecd1b8fd085f0f8@s5r6.in-berlin.de>
References: <tkrat.671196999e56464f@s5r6.in-berlin.de>
 <tkrat.e3130c87f5d2851a@s5r6.in-berlin.de>
 <tkrat.66ea5df34ac46da2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Apr, Stefan Richter wrote:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following IEEE 1394/ FireWire subsystem update.
> Thanks.
> 
> Clemens Ladisch (3):
>       firewire: cdev: disallow receive packets without header
>       firewire: cdev: require quadlet-aligned headers for transmit packets
>       firewire: cdev: iso packet documentation
> 
> Stefan Richter (3):
>       firewire: cdev: fix information leak
>       firewire: cdev: comment fixlet
>       firewire: cdev: change license of exported header files to MIT license
> 
>  drivers/firewire/core-cdev.c       |   23 ++++++-----
>  include/linux/firewire-cdev.h      |   78 +++++++++++++++++++++++++-----------
>  include/linux/firewire-constants.h |   29 ++++++++++++-
>  3 files changed, 95 insertions(+), 35 deletions(-)
> 
> Since several of these patches were not copied to linux-kernel yet, I
> will send the full log and diff in a reply to this message.

commit 19b3eecc21b65a24b0aae2684ca0c8e1b99ef802
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Apr 11 11:52:12 2010 +0200

    firewire: cdev: change license of exported header files to MIT license
    
    Among else, this allows projects like libdc1394 to carry copies of the
    ABI related header files without them or distributors having to worry
    about effects on the project's overall license terms.  Switch to MIT
    license as suggested by Kristian.  Also update the year in the
    copyright statement according to source history.
    
    Cc: Jay Fenlason <fenlason@redhat.com>
    Acked-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
---
 include/linux/firewire-cdev.h      |   29 +++++++++++++++++------------
 include/linux/firewire-constants.h |   29 +++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index 6ffb24a..81f3b14 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -1,21 +1,26 @@
 /*
  * Char device interface.
  *
- * Copyright (C) 2005-2006  Kristian Hoegsberg <krh@bitplanet.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright (C) 2005-2007  Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
  */
 
 #ifndef _LINUX_FIREWIRE_CDEV_H
diff --git a/include/linux/firewire-constants.h b/include/linux/firewire-constants.h
index b316770..9c63f06 100644
--- a/include/linux/firewire-constants.h
+++ b/include/linux/firewire-constants.h
@@ -1,3 +1,28 @@
+/*
+ * IEEE 1394 constants.
+ *
+ * Copyright (C) 2005-2007  Kristian Hoegsberg <krh@bitplanet.net>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
 #ifndef _LINUX_FIREWIRE_CONSTANTS_H
 #define _LINUX_FIREWIRE_CONSTANTS_H
 
@@ -21,7 +46,7 @@
 #define EXTCODE_WRAP_ADD		0x6
 #define EXTCODE_VENDOR_DEPENDENT	0x7
 
-/* Juju specific tcodes */
+/* Linux firewire-core (Juju) specific tcodes */
 #define TCODE_LOCK_MASK_SWAP		(0x10 | EXTCODE_MASK_SWAP)
 #define TCODE_LOCK_COMPARE_SWAP		(0x10 | EXTCODE_COMPARE_SWAP)
 #define TCODE_LOCK_FETCH_ADD		(0x10 | EXTCODE_FETCH_ADD)
@@ -36,7 +61,7 @@
 #define RCODE_TYPE_ERROR		0x6
 #define RCODE_ADDRESS_ERROR		0x7
 
-/* Juju specific rcodes */
+/* Linux firewire-core (Juju) specific rcodes */
 #define RCODE_SEND_ERROR		0x10
 #define RCODE_CANCELLED			0x11
 #define RCODE_BUSY			0x12

commit ca658b1e29d6be939207532e337fb640eb697f71
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Apr 10 12:23:09 2010 +0200

    firewire: cdev: comment fixlet
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index 011fdf1..6ffb24a 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -647,8 +647,8 @@ struct fw_cdev_get_cycle_timer2 {
  * instead of allocated.
  * An %FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED event concludes this operation.
  *
- * To summarize, %FW_CDEV_IOC_DEALLOCATE_ISO_RESOURCE allocates iso resources
- * for the lifetime of the fd or handle.
+ * To summarize, %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE allocates iso resources
+ * for the lifetime of the fd or @handle.
  * In contrast, %FW_CDEV_IOC_ALLOCATE_ISO_RESOURCE_ONCE allocates iso resources
  * for the duration of a bus generation.
  *

commit aa6fec3cdeb14ecc916eb78c4cd9ed79e4f7fe8d
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Wed Mar 31 16:26:52 2010 +0200

    firewire: cdev: iso packet documentation
    
    Add the missing documentation for iso packets.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/firewire-cdev.h |   39 +++++++++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index 40b1101..011fdf1 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -438,7 +438,7 @@ struct fw_cdev_remove_descriptor {
  * @type:	%FW_CDEV_ISO_CONTEXT_TRANSMIT or %FW_CDEV_ISO_CONTEXT_RECEIVE
  * @header_size: Header size to strip for receive contexts
  * @channel:	Channel to bind to
- * @speed:	Speed to transmit at
+ * @speed:	Speed for transmit contexts
  * @closure:	To be returned in &fw_cdev_event_iso_interrupt
  * @handle:	Handle to context, written back by kernel
  *
@@ -451,6 +451,9 @@ struct fw_cdev_remove_descriptor {
  * If a context was successfully created, the kernel writes back a handle to the
  * context, which must be passed in for subsequent operations on that context.
  *
+ * For receive contexts, @header_size must be at least 4 and must be a multiple
+ * of 4.
+ *
  * Note that the effect of a @header_size > 4 depends on
  * &fw_cdev_get_info.version, as documented at &fw_cdev_event_iso_interrupt.
  */
@@ -481,10 +484,34 @@ struct fw_cdev_create_iso_context {
  *
  * &struct fw_cdev_iso_packet is used to describe isochronous packet queues.
  *
- * Use the FW_CDEV_ISO_ macros to fill in @control.  The sy and tag fields are
- * specified by IEEE 1394a and IEC 61883.
- *
- * FIXME - finish this documentation
+ * Use the FW_CDEV_ISO_ macros to fill in @control.
+ *
+ * For transmit packets, the header length must be a multiple of 4 and specifies
+ * the numbers of bytes in @header that will be prepended to the packet's
+ * payload; these bytes are copied into the kernel and will not be accessed
+ * after the ioctl has returned.  The sy and tag fields are copied to the iso
+ * packet header (these fields are specified by IEEE 1394a and IEC 61883-1).
+ * The skip flag specifies that no packet is to be sent in a frame; when using
+ * this, all other fields except the interrupt flag must be zero.
+ *
+ * For receive packets, the header length must be a multiple of the context's
+ * header size; if the header length is larger than the context's header size,
+ * multiple packets are queued for this entry.  The sy and tag fields are
+ * ignored.  If the sync flag is set, the context drops all packets until
+ * a packet with a matching sy field is received (the sync value to wait for is
+ * specified in the &fw_cdev_start_iso structure).  The payload length defines
+ * how many payload bytes can be received for one packet (in addition to payload
+ * quadlets that have been defined as headers and are stripped and returned in
+ * the &fw_cdev_event_iso_interrupt structure).  If more bytes are received, the
+ * additional bytes are dropped.  If less bytes are received, the remaining
+ * bytes in this part of the payload buffer will not be written to, not even by
+ * the next packet, i.e., packets received in consecutive frames will not
+ * necessarily be consecutive in memory.  If an entry has queued multiple
+ * packets, the payload length is divided equally among them.
+ *
+ * When a packet with the interrupt flag set has been completed, the
+ * &fw_cdev_event_iso_interrupt event will be sent.  An entry that has queued
+ * multiple receive packets is completed when its last packet is completed.
  */
 struct fw_cdev_iso_packet {
 	__u32 control;
@@ -501,7 +528,7 @@ struct fw_cdev_iso_packet {
  * Queue a number of isochronous packets for reception or transmission.
  * This ioctl takes a pointer to an array of &fw_cdev_iso_packet structs,
  * which describe how to transmit from or receive into a contiguous region
- * of a mmap()'ed payload buffer.  As part of the packet descriptors,
+ * of a mmap()'ed payload buffer.  As part of transmit packet descriptors,
  * a series of headers can be supplied, which will be prepended to the
  * payload during DMA.
  *

commit 9cac00b8f0079d5d3d54ec4dae453d58dec30e7c
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Apr 7 08:30:50 2010 +0200

    firewire: cdev: fix information leak
    
    A userspace client got to see uninitialized stack-allocated memory if it
    specified an _IOC_READ type of ioctl and an argument size larger than
    expected by firewire-core's ioctl handlers (but not larger than the
    core's union ioctl_arg).
    
    Fix this by clearing the requested buffer size to zero, but only at _IOR
    ioctls.  This way, there is almost no runtime penalty to legitimate
    ioctls.  The only legitimate _IOR is FW_CDEV_IOC_GET_CYCLE_TIMER with 12
    or 16 bytes to memset.
    
    [Another way to fix this would be strict checking of argument size (and
    possibly direction) vs. command number.  However, we then need a lookup
    table, and we need to allow for slight size deviations in case of 32bit
    userland on 64bit kernel.]
    
    Reported-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 5eba9e0..0d3df09 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1356,24 +1356,24 @@ static int dispatch_ioctl(struct client *client,
 		return -ENODEV;
 
 	if (_IOC_TYPE(cmd) != '#' ||
-	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers))
+	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers) ||
+	    _IOC_SIZE(cmd) > sizeof(buffer))
 		return -EINVAL;
 
-	if (_IOC_DIR(cmd) & _IOC_WRITE) {
-		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
+	if (_IOC_DIR(cmd) == _IOC_READ)
+		memset(&buffer, 0, _IOC_SIZE(cmd));
+
+	if (_IOC_DIR(cmd) & _IOC_WRITE)
+		if (copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
 			return -EFAULT;
-	}
 
 	ret = ioctl_handlers[_IOC_NR(cmd)](client, &buffer);
 	if (ret < 0)
 		return ret;
 
-	if (_IOC_DIR(cmd) & _IOC_READ) {
-		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_to_user(arg, &buffer, _IOC_SIZE(cmd)))
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		if (copy_to_user(arg, &buffer, _IOC_SIZE(cmd)))
 			return -EFAULT;
-	}
 
 	return ret;
 }

commit 385ab5bcd4be586dffdba550b310308d89eade71
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Wed Mar 31 16:26:46 2010 +0200

    firewire: cdev: require quadlet-aligned headers for transmit packets
    
    The definition of struct fw_cdev_iso_packet seems to imply that the
    header_length must be quadlet-aligned, and in fact, specifying an
    unaligned header has never really worked when using multiple packet
    structures, because the position of the next control word is computed by
    rounding the header_length _down_, so the last one to three bytes of the
    header would overlap the next control word.
    
    To avoid this problem, check that the header length is properly aligned.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index bbb8160..5eba9e0 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -959,6 +959,8 @@ static int ioctl_queue_iso(struct client *client, union ioctl_arg *arg)
 		u.packet.header_length = GET_HEADER_LENGTH(control);
 
 		if (ctx->type == FW_ISO_CONTEXT_TRANSMIT) {
+			if (u.packet.header_length % 4 != 0)
+				return -EINVAL;
 			header_length = u.packet.header_length;
 		} else {
 			/*

commit 4ba1d9c0c22947a9207029e7184733252e6135f1
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Wed Mar 31 16:26:39 2010 +0200

    firewire: cdev: disallow receive packets without header
    
    In receive contexts, reject packets with header_length==0.  This would
    be an instruction to queue zero packets which would not make sense.
    
    This prevents a division by zero in the OHCI driver.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 8be720b..bbb8160 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -968,7 +968,8 @@ static int ioctl_queue_iso(struct client *client, union ioctl_arg *arg)
 			if (ctx->header_size == 0) {
 				if (u.packet.header_length > 0)
 					return -EINVAL;
-			} else if (u.packet.header_length % ctx->header_size != 0) {
+			} else if (u.packet.header_length == 0 ||
+				   u.packet.header_length % ctx->header_size != 0) {
 				return -EINVAL;
 			}
 			header_length = 0;

-- 
Stefan Richter
-=====-==-=- -=-- -====
http://arcgraph.de/sr/

