Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1GVNJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:09:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46405 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1GVNJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:09:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 22 Jul 2011 15:08:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post 3.0
Message-ID: <20110722150847.0d9352ef@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates for the IEEE 1394 (FireWire) subsystem.
This brings yet another reduction of CPU utilization, corrections of two
obscure issues in the userspace driver ABI, documentation, and the usual
housekeeping.

Thanks.

August Lilleaas (1):
      firewire: net: replacing deprecated __attribute__((packed)) with __packed

Clemens Ladisch (1):
      firewire: ohci: remove superfluous posted write flushes

Stefan Richter (8):
      firewire: ohci: reduce potential context_stop latency
      firewire: ohci: add a comment on PHY reg access serialization
      firewire: ohci: fix PHY reg access after card ejection
      firewire: ohci: skip soft reset retries after card ejection
      firewire: cdev: return -ENOTTY for unimplemented ioctls, not -EINVAL
      firewire: cdev: prevent race between first get_info ioctl and bus reset event queuing
      firewire: cdev: ABI documentation enhancements
      firewire: document the sysfs ABIs

 Documentation/ABI/stable/firewire-cdev      |  103 ++++++++++++++++++++++
 Documentation/ABI/stable/sysfs-bus-firewire |  122 +++++++++++++++++++++++++++
 drivers/firewire/core-cdev.c                |   20 +++--
 drivers/firewire/net.c                      |    5 +-
 drivers/firewire/ohci.c                     |   42 ++++++----
 include/linux/firewire-cdev.h               |   78 ++++++++---------
 6 files changed, 303 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/ABI/stable/firewire-cdev
 create mode 100644 Documentation/ABI/stable/sysfs-bus-firewire
-- 
Stefan Richter
-=====-==-== -=== =-==-
http://arcgraph.de/sr/
