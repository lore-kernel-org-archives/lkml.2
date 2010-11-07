Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0KGVif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:38:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45094 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0KGVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:38:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 7 Nov 2010 22:38:20 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] firewire-net updates
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <tkrat.036c5d10fb83f85d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a repost of yesterday's patches for firewire-net.  I dropped the
error logging limitation.

firewire: net: count stats.tx_packets and stats.tx_bytes
firewire: net: fix memory leaks
firewire: net: replace lists by counters
firewire: net: throttle TX queue before running out of tlabels

 drivers/firewire/net.c |  137 ++++++++++++++++++++++++-----------------
 1 file changed, 83 insertions(+), 54 deletions(-)
-- 
Stefan Richter
-=====-==-=- =-== --===
http://arcgraph.de/sr/


