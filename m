Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0DOQAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:00:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45962 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab0DOQAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:00:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 15 Apr 2010 17:59:52 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes and documentation update
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.e3130c87f5d2851a@s5r6.in-berlin.de>
Message-ID: <tkrat.66ea5df34ac46da2@s5r6.in-berlin.de>
References: <tkrat.671196999e56464f@s5r6.in-berlin.de>
 <tkrat.e3130c87f5d2851a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem update.
Thanks.

Clemens Ladisch (3):
      firewire: cdev: disallow receive packets without header
      firewire: cdev: require quadlet-aligned headers for transmit packets
      firewire: cdev: iso packet documentation

Stefan Richter (3):
      firewire: cdev: fix information leak
      firewire: cdev: comment fixlet
      firewire: cdev: change license of exported header files to MIT license

 drivers/firewire/core-cdev.c       |   23 ++++++-----
 include/linux/firewire-cdev.h      |   78 +++++++++++++++++++++++++-----------
 include/linux/firewire-constants.h |   29 ++++++++++++-
 3 files changed, 95 insertions(+), 35 deletions(-)

Since several of these patches were not copied to linux-kernel yet, I
will send the full log and diff in a reply to this message.
-- 
Stefan Richter
-=====-==-=- -=-- -====
http://arcgraph.de/sr/

