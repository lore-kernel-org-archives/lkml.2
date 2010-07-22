Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0GVRup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:50:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41883 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab0GVRul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:50:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 22 Jul 2010 19:50:32 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [review patch 3/2] firewire: nosy: note ioctls in ioctl-number.txt
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@vger.kernel.org, Kristian Hoegsberg <krh@bitplanet.net>,
        Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <4C487F2B.4040405@s5r6.in-berlin.de>
Message-ID: <tkrat.8da176e6aa2f4ff6@s5r6.in-berlin.de>
References: <tkrat.72756f504d6c0055@s5r6.in-berlin.de>
 <tkrat.ddc816ab75cce8ac@s5r6.in-berlin.de>
 <20100722090751.682f3b00.randy.dunlap@oracle.com>
 <4C487F2B.4040405@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the ioctls for the special-purpose misc device /dev/nosy, the
interface to the IEEE 1394 packet sniffer/ protocol analyzer driver.
Currently only the numbers 00...02 are in use; let's block a few more
for unforeseen use cases.

Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Kristian Høgsberg <krh@bitplanet.net>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

As mentioned in patch 1/2, this is up for discussion.  These ioctls have
been used during nosy's out-of-tree life for several years; but due to
the nature of this driver and its frontend as special-purpose
application on special hardware, an incompatible change of these ioctls
in the process of mainline merge won't be overly hurtful.

 Documentation/ioctl/ioctl-number.txt |    1 +
 1 file changed, 1 insertion(+)

Index: b/Documentation/ioctl/ioctl-number.txt
===================================================================
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -79,6 +79,7 @@ Code  Seq#(hex)	Include File		Comments
 0x22	all	scsi/sg.h
 '#'	00-3F	IEEE 1394 Subsystem	Block for the entire subsystem
 '$'	00-0F	linux/perf_counter.h, linux/perf_event.h
+'&'	00-07	drivers/firewire/nosy-user.h
 '1'	00-1F	<linux/timepps.h>	PPS kit from Ulrich Windl
 					<ftp://ftp.de.kernel.org/pub/linux/daemons/ntp/PPS/>
 '2'	01-04	linux/i2o.h

-- 
Stefan Richter
-=====-==-=- -=== =-==-
http://arcgraph.de/sr/

