Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0K1NHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 08:07:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44160 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0K1NHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 08:07:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 28 Nov 2010 14:07:14 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fixes
Message-ID: <20101128140714.3e77e73d@stein>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the fwnet branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git fwnet

to receive fixes for some older issues.  These modify the experimental
IPv4-over-1394 firewire-net driver only and have been appropriately
stress-tested.  Thanks to Maxim Levitsky for a lot of help with that.
So the probability and risk of regressions are very low.

Stefan Richter (4):
      firewire: net: count stats.tx_packets and stats.tx_bytes
      firewire: net: fix memory leaks
      firewire: net: replace lists by counters
      firewire: net: throttle TX queue before running out of tlabels

 drivers/firewire/net.c |  160 +++++++++++++++++++++++++++---------------------
 1 files changed, 90 insertions(+), 70 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==-=- =-== ===--
http://arcgraph.de/sr/
