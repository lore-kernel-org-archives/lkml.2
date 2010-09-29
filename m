Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab0I2JIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 05:08:13 -0400
Received: from sour.ops.eusc.inter.net ([84.23.254.154]:49552 "EHLO
	sour.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0I2JII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 05:08:08 -0400
X-Greylist: delayed 1650 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2010 05:08:08 EDT
X-Trace: 4d7c73656261737469616e2e6b6c6f736b6140736e6166752e64657c38352e3137
	382e36372e3235307c31503073444d2d3030304f636f2d43737c31323835373439
	363336
Message-ID: <4CA2FB7C.5010509@snafu.de>
Date: Wed, 29 Sep 2010 10:40:28 +0200
From: Oncaphillis <oncaphillis@snafu.de>
Reply-To: oncaphillis@snafu.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: forcedeth trouble in 2.6.34.6 ?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  I'm running a 2.6.34 (64bit) with Fedora 13 using the forcedeth
network driver. Sometimes a ǵo I noticed that the driver fails
to initialize the network connection properly. The HUB tells me
I have a connection and ifconfig and ethtools seem to report
the card as being properly set up. But nothing goes over the lines.
No DHCP or any other communication. Removing and inserting the
driver (sometimes more then once) solves the problem.

  Since the hardware is rather old I thought the NIC is broken
and I added another card. Now I have set up a new computer with
another nvidia chipset and have to find out that
it seems to be a driver issue.

  I found some random complains about the NIC and the driver in the
net which seem to report similar issues (NIC dead on boot etc..)
but all of these seem to refer to older kernels like 2.6.27 and
such. There also didn't come up much under bugzilla.kernel.org
for 2.6.24 when I search for forcedeth

  Is that a known issue ?

Cheers

  O.

== lspci -v ==

Old Mainboard AMD Althlon 642X

00:05.0 Bridge: nVidia Corporation CK8S Ethernet Controller (rev a2)
         Subsystem: Holco Enterprise Co, Ltd/Shuttle Computer Device a551
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
         Memory at fdffc000 (32-bit, non-prefetchable) [size=4K]
         I/O ports at fc00 [size=8]
         Capabilities: [44] Power Management version 2
         Kernel driver in use: forcedeth
         Kernel modules: forcedeth

New MainBoard Intel Quad Core

00:0a.0 Ethernet controller: nVidia Corporation MCP79 Ethernet (rev b1)
         Subsystem: ZOTAC International (MCO) Ltd. Device 0ae5
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
         Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
         I/O ports at fc00 [size=8]
         Memory at fe02a000 (32-bit, non-prefetchable) [size=256]
         Memory at fe029000 (32-bit, non-prefetchable) [size=16]
         Capabilities: [44] Power Management version 2
         Kernel driver in use: forcedeth
         Kernel modules: forcedeth

