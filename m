Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0H2JyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:54:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43904 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab0H2JyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:54:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 29 Aug 2010 11:54:01 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.d6b3e8e7fd9a72dc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive fixes for
  - three older issues in firewire-sbp2 and -net,
  - a timer misuse added in 2.6.35 in firewire-core,
  - a hardware quirk that obstructed a 2.6.36-rc1 feature in firewire-ohci.
Thanks.

Clemens Ladisch (1):
      firewire: core: do not use del_timer_sync() in interrupt context

Julia Lawall (1):
      ieee1394: Adjust confusing if indentation

Stefan Richter (4):
      firewire: sbp2: fix memory leak in sbp2_cancel_orbs or at send error
      firewire: sbp2: fix stall with "Unsolicited response"
      firewire: net: fix unicast reception RCODE in failure paths
      firewire: ohci: work around VIA and NEC PHY packet reception bug

 drivers/firewire/core-transaction.c |   13 ++++++++++---
 drivers/firewire/net.c              |   28 +++++++++++++++-------------
 drivers/firewire/ohci.c             |   10 +++++++++-
 drivers/firewire/sbp2.c             |   23 +++++++++++++++--------
 drivers/ieee1394/ohci1394.c         |    2 +-
 5 files changed, 50 insertions(+), 26 deletions(-)
-- 
Stefan Richter
-=====-==-=- =--- ===-=
http://arcgraph.de/sr/

