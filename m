Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579Ab1KCTd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:33:29 -0400
Received: from lo.gmane.org ([80.91.229.12]:57081 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab1KCTd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:33:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mantas M." <grawity@gmail.com>
Subject: memstick - old Memory Sticks not recognized
Date: Thu, 03 Nov 2011 21:33:10 +0200
Message-ID: <j8uq9n$dvd$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080701080806050303050208"
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 78-60-211-195.static.zebra.lt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111005 Thunderbird/8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080701080806050303050208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have a few Sony Memory Stick cards laying around, and tried to use 
them with my laptop's card reader. Unfortunately, while the reader seems 
to recognize all cards, Linux does not -- only the "Memory Stick Pro" 
series one is recognized as a mountable block device. The other two, 
from the original "Memory Stick" series, are not. (They work fine in a 
camera, however.)

Ideas? Patches?

Linux 3.1.0-09034-g70c9f18.

-- 
Mantas M.

--------------080701080806050303050208
Content-Type: text/plain;
 name="card1-ms-128m.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="card1-ms-128m.dmesg"

(card inserted)
[  871.210930] jmb38x_ms 0000:05:00.3: irq_status = 00000008
[  871.210934] jmb38x_ms 0000:05:00.3: media changed
[  871.210951] memstick_host memstick0: memstick_check started
[  871.223747] jmb38x_ms 0000:05:00.3: power on
[  871.223754] jmb38x_ms 0000:05:00.3: Set Host Interface Mode to 0
[  871.223770] jmb38x_ms 0000:05:00.3: tasklet req 0
[  871.223777] memstick_host memstick0: control 000540c7
[  871.223782] memstick_host memstick0: status 00000000
[  871.223787] memstick_host memstick0: hstatus 00000600
[  871.223794] memstick_host memstick0: executing TPC 00080004, len 4
[  871.223853] jmb38x_ms 0000:05:00.3: irq_status = 00000001
[  871.223859] memstick_host memstick0: c control 000544c7
[  871.223863] memstick_host memstick0: c status 00000000
[  871.223868] memstick_host memstick0: c hstatus 00000600
[  871.223892] jmb38x_ms 0000:05:00.3: tasklet req 0
[  871.223898] memstick_host memstick0: control 000540c7
[  871.223901] memstick_host memstick0: status 00000000
[  871.223905] memstick_host memstick0: hstatus 00000600
[  871.223909] memstick_host memstick0: executing TPC 00044004, len 4
[  871.224000] jmb38x_ms 0000:05:00.3: irq_status = 00000001
[  871.224011] memstick_host memstick0: c control 000544c7
[  871.224017] memstick_host memstick0: c status 00000000
[  871.224022] memstick_host memstick0: c hstatus 00000600
[  871.224031] memstick memstick0: if_mode = 00
[  871.224046] memstick_host memstick0: new card 00, 00, 00
[  871.224146] memstick_host memstick0: memstick_check finished
(card removed)
[  915.857652] jmb38x_ms 0000:05:00.3: irq_status = 00000010
[  915.857657] jmb38x_ms 0000:05:00.3: media changed
[  915.857674] memstick_host memstick0: memstick_check started
[  915.857687] jmb38x_ms 0000:05:00.3: tasklet req 0
[  915.857692] memstick_host memstick0: no media status
[  915.857695] jmb38x_ms 0000:05:00.3: tasklet req 0
[  915.857699] memstick_host memstick0: no media status
[  915.857702] jmb38x_ms 0000:05:00.3: tasklet req 0
[  915.857706] memstick_host memstick0: no media status
[  915.857710] jmb38x_ms 0000:05:00.3: tasklet req -11
[  915.857900] jmb38x_ms 0000:05:00.3: power off
[  915.857902] memstick_host memstick0: memstick_check finished

--------------080701080806050303050208
Content-Type: text/plain;
 name="card1-ms-128m.udev"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="card1-ms-128m.udev"

monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[867.357117] add      /devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0 (memstick)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0
MEMSTICK_CATEGORY=00
MEMSTICK_CLASS=00
MEMSTICK_TYPE=00
SEQNUM=1990
SUBSYSTEM=memstick
UDEV_LOG=3

UDEV  [867.358732] add      /devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0 (memstick)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0
MEMSTICK_CATEGORY=00
MEMSTICK_CLASS=00
MEMSTICK_TYPE=00
SEQNUM=1990
SUBSYSTEM=memstick
UDEV_LOG=3
USEC_INITIALIZED=867357458

KERNEL[911.987512] remove   /devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0 (memstick)
ACTION=remove
DEVPATH=/devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0
MEMSTICK_CATEGORY=00
MEMSTICK_CLASS=00
MEMSTICK_TYPE=00
SEQNUM=1991
SUBSYSTEM=memstick
UDEV_LOG=3

UDEV  [911.987833] remove   /devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0 (memstick)
ACTION=remove
DEVPATH=/devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0
MEMSTICK_CATEGORY=00
MEMSTICK_CLASS=00
MEMSTICK_TYPE=00
SEQNUM=1991
SUBSYSTEM=memstick
UDEV_LOG=3
USEC_INITIALIZED=911987557


--------------080701080806050303050208
Content-Type: text/plain;
 name="card2-ms-16m.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="card2-ms-16m.dmesg"

(card inserted)
[  965.754858] jmb38x_ms 0000:05:00.3: irq_status = 00000008
[  965.754863] jmb38x_ms 0000:05:00.3: media changed
[  965.754880] memstick_host memstick0: memstick_check started
[  965.768051] jmb38x_ms 0000:05:00.3: power on
[  965.768058] jmb38x_ms 0000:05:00.3: Set Host Interface Mode to 0
[  965.768074] jmb38x_ms 0000:05:00.3: tasklet req 0
[  965.768082] memstick_host memstick0: control 000540c7
[  965.768087] memstick_host memstick0: status 00000000
[  965.768091] memstick_host memstick0: hstatus 00001600
[  965.768098] memstick_host memstick0: executing TPC 00080004, len 4
[  965.768154] jmb38x_ms 0000:05:00.3: irq_status = 00000001
[  965.768160] memstick_host memstick0: c control 000544c7
[  965.768165] memstick_host memstick0: c status 00000000
[  965.768170] memstick_host memstick0: c hstatus 00001600
[  965.768194] jmb38x_ms 0000:05:00.3: tasklet req 0
[  965.768204] memstick_host memstick0: control 000540c7
[  965.768207] memstick_host memstick0: status 00000000
[  965.768211] memstick_host memstick0: hstatus 00001600
[  965.768215] memstick_host memstick0: executing TPC 00044004, len 4
[  965.768304] jmb38x_ms 0000:05:00.3: irq_status = 00000001
[  965.768315] memstick_host memstick0: c control 000544c7
[  965.768320] memstick_host memstick0: c status 00000000
[  965.768325] memstick_host memstick0: c hstatus 00001600
[  965.768334] memstick memstick0: if_mode = 00
[  965.768350] memstick_host memstick0: new card 00, 00, 00
[  965.768447] memstick_host memstick0: memstick_check finished
(card removed)
[  970.235117] jmb38x_ms 0000:05:00.3: irq_status = 00000010
[  970.235121] jmb38x_ms 0000:05:00.3: media changed
[  970.235139] memstick_host memstick0: memstick_check started
[  970.235152] jmb38x_ms 0000:05:00.3: tasklet req 0
[  970.235157] memstick_host memstick0: no media status
[  970.235160] jmb38x_ms 0000:05:00.3: tasklet req 0
[  970.235165] memstick_host memstick0: no media status
[  970.235167] jmb38x_ms 0000:05:00.3: tasklet req 0
[  970.235171] memstick_host memstick0: no media status
[  970.235175] jmb38x_ms 0000:05:00.3: tasklet req -11
[  970.235334] jmb38x_ms 0000:05:00.3: power off
[  970.235339] memstick_host memstick0: memstick_check finished

--------------080701080806050303050208
Content-Type: text/plain;
 name="card2-ms-16m.udev"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="card2-ms-16m.udev"

monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[961.897152] add      /devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0 (memstick)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0
MEMSTICK_CATEGORY=00
MEMSTICK_CLASS=00
MEMSTICK_TYPE=00
SEQNUM=1992
SUBSYSTEM=memstick
UDEV_LOG=3

UDEV  [961.898702] add      /devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0 (memstick)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0
MEMSTICK_CATEGORY=00
MEMSTICK_CLASS=00
MEMSTICK_TYPE=00
SEQNUM=1992
SUBSYSTEM=memstick
UDEV_LOG=3
USEC_INITIALIZED=961897429

KERNEL[966.364672] remove   /devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0 (memstick)
ACTION=remove
DEVPATH=/devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0
MEMSTICK_CATEGORY=00
MEMSTICK_CLASS=00
MEMSTICK_TYPE=00
SEQNUM=1993
SUBSYSTEM=memstick
UDEV_LOG=3

UDEV  [966.364936] remove   /devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0 (memstick)
ACTION=remove
DEVPATH=/devices/pci0000:00/0000:00:1c.5/0000:05:00.3/memstick_host/memstick0/memstick0
MEMSTICK_CATEGORY=00
MEMSTICK_CLASS=00
MEMSTICK_TYPE=00
SEQNUM=1993
SUBSYSTEM=memstick
UDEV_LOG=3
USEC_INITIALIZED=966364672


--------------080701080806050303050208--

