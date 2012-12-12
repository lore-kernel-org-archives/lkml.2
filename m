Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2LLV0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:26:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45659 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2LLV0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:26:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 12 Dec 2012 22:26:18 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.7
Message-ID: <20121212222618.4344c2f8@stein>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
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
  - IPv4-over-1394: fixes for broadcast and multicast
  - SBP-2: allow thin-provisioning related commands
  - trivia
Thanks.

Stefan Richter (2):
      tools/firewire: nosy-dump: check for allocation failure
      firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED OPERATION CODES

Stephan Gatzka (1):
      firewire: net: Fix handling of fragmented multicast/broadcast packets.

Wei Yongjun (1):
      firewire: net: remove unused variable in fwnet_receive_broadcast()

 drivers/firewire/net.c     | 15 +++++++++------
 drivers/firewire/sbp2.c    |  2 --
 tools/firewire/nosy-dump.c |  4 ++++
 3 files changed, 13 insertions(+), 8 deletions(-)
-- 
Stefan Richter
-=====-===-- ==-- -==--
http://arcgraph.de/sr/
