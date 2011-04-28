Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab1D1NLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:11:23 -0400
Received: from sx003.ddc-nl0105.slb.com ([199.6.154.22]:48226 "EHLO
	nl0105mta01.mail.slb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1D1NLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:11:21 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Apr 2011 09:11:21 EDT
From: John Frankish <j-frankish@slb.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ipheth kernel oops
Thread-Topic: ipheth kernel oops
Thread-Index: AcwFozjsz9t5ro9xSKe0AeC68rTH8w==
Date: Thu, 28 Apr 2011 13:00:59 +0000
Message-ID: <654DF80AD31A344E93DBCC6280BD6DEF19339262@NL0230MBX08N1.DIR.slb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.6.132.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please cc my email address as I am not subscribed to the list.

Using ipheth from git://github.com/dgiagio/ipheth.git with:

libimobiledevice-1.0.6
usbmuxd-1.0.7
libplist-1.3 
iPhone 3GS using OS4.3.2

after connecting via usb cable, verifying usbmuxd is running and the device is paired:

$ sudo udhcpc -i eth1

ipheth 1-7:4.2: Apple iPhone USB Ethernet device attached
usbcore: registered new interface driver ipheth
 ------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:255 0xc034f714()
Hardware name: Latitude D430                   
NETDEV WATCHDOG: eth1 (ipheth): transmit queue 0 timed out Modules linked in: ipheth squashfs scsi_wait_scan ramzswap loop pcmcia
yenta_socket sdhci_pci dell_wmi video sdhci rsrc_nonstatic backlight wmi battery pcmcia_core ac output mmc_core tg3 ssb libphy
Pid: 0, comm: swapper Not tainted 2.6.33.3-tinycore #2012 Call Trace:
 [<c0128285>] ? 0xc0128285
 [<c034f64d>] ? 0xc034f64d
 [<c01282ca>] ? 0xc01282ca
 [<c034f714>] ? 0xc034f714
 [<c013a661>] ? 0xc013a661
 [<c01242b2>] ? 0xc01242b2
 [<c01138e2>] ? 0xc01138e2
 [<c0113ab5>] ? 0xc0113ab5
 [<c01402ff>] ? 0xc01402ff
 [<c012faa4>] ? 0xc012faa4
 [<c012fbb4>] ? 0xc012fbb4
 [<c012c1af>] ? 0xc012c1af
 [<c012c252>] ? 0xc012c252
 [<c012c5d4>] ? 0xc012c5d4
 [<c0114204>] ? 0xc0114204
 [<c03bd06a>] ? 0xc03bd06a
 [<c026ce02>] ? 0xc026ce02
 [<c032a7bd>] ? 0xc032a7bd
 [<c01017e9>] ? 0xc01017e9
---[ end trace debb96b4aa274556 ]---
ipheth: ipheth_tx_timeout: TX timeout
