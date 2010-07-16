Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab0GPUXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:23:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57982 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab0GPUXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:23:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 16 Jul 2010 22:23:30 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] firewire: 2 simple updates + 2 ABI additions: PHY packet
 tx/rx
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.59dee0979cf9dbb0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coming as replies:

[PATCH 1/4] firewire: cdev: some clarifications to the API documentation
[PATCH 2/4] firewire: core: use C99 initializer in array of ioctl handlers
[PATCH 3/4 RFC] firewire: cdev: add PHY packet transmission
[PATCH 4/4 RFC] firewire: cdev: add PHY packet reception

 drivers/firewire/core-card.c        |    1 
 drivers/firewire/core-cdev.c        |  179 ++++++++++++++++++++++++++++++------
 drivers/firewire/core-transaction.c |    5 +
 drivers/firewire/core.h             |    2 
 drivers/firewire/ohci.c             |    3 
 include/linux/firewire-cdev.h       |   98 ++++++++++++++++++-
 include/linux/firewire.h            |    3 
 7 files changed, 254 insertions(+), 37 deletions(-)

A libraw1394 backend counterpart to patch 3/4 will be posted to
linux1394-devel.  It can be tested with firecontrol.

A simple test tool for patch 4/4 will be posted to linux1394-devel too.
-- 
Stefan Richter
-=====-==-=- -=== =----
http://arcgraph.de/sr/

