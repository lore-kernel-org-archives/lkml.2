Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2G2JNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 05:13:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55588 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2G2JNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 05:13:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 29 Jul 2012 11:13:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.5
Message-ID: <20120729111303.1e4af44e@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-updates" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-updates

to receive the following IEEE 1394 (FireWire) subsystem changes:

 - Small fixes and optimizations.

 - A new sysfs attribute to tell local and remote nodes apart.
   Useful to set special permissions/ ownership of local nodes'
   /dev/fw*, to start daemons on them (for diagnostics, management,
   AV targets, VersaPHY initiator or targets...), to pick up their
   GUID to use it as GUID of an SBP2 target instance, and of course
   for informational purposes.

Clemens Ladisch (7):
      firewire: core: make address handler length 64 bits
      firewire: core: allocate the low memory region
      firewire: ohci: lazy bus time initialization
      firewire: ohci: sanity-check MMIO resource
      firewire: core: fix multichannel IR with buffers larger than 2 GB
      firewire: ohci: initialize multiChanMode bits after reset
      firewire: core: add is_local sysfs device attribute

Stefan Richter (1):
      firewire: core: document is_local sysfs attribute

 Documentation/ABI/stable/sysfs-bus-firewire |   11 +++++++++++
 drivers/firewire/core-device.c              |    9 +++++++++
 drivers/firewire/core-iso.c                 |    2 +-
 drivers/firewire/core-transaction.c         |   23 +++++++++++++++++++++--
 drivers/firewire/ohci.c                     |   30 ++++++++++++++++++++++++------
 include/linux/firewire.h                    |    4 ++--
 6 files changed, 68 insertions(+), 11 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-===-- -=== ===-=
http://arcgraph.de/sr/
