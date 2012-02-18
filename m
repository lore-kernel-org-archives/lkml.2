Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2BRU6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 15:58:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52733 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2BRU6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 15:58:40 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Feb 2012 21:58:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] firewire, some more logging related patches
Message-ID: <20120218215824.5b2359bf@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forthcoming:
  * firewire: sbp2: identify to driver core as "firewire_sbp2", not "sbp2"
  * firewire: net: identify to driver core as "firewire_net", not "net"
  * firewire: net: prefix all log messages with interface name
  * firewire: core: prefix log messages with card name

 drivers/firewire/core-card.c        |   28 ++++++++++---
 drivers/firewire/core-cdev.c        |   10 ++--
 drivers/firewire/core-device.c      |   60 +++++++++++++---------------
 drivers/firewire/core-topology.c    |   18 ++++----
 drivers/firewire/core-transaction.c |    4 -
 drivers/firewire/core.h             |    6 ++
 drivers/firewire/net.c              |   45 ++++++++++++---------
 drivers/firewire/sbp2.c             |    6 --
 include/linux/firewire.h            |    3 -
 9 files changed, 100 insertions(+), 80 deletions(-)
-- 
Stefan Richter
-=====-===-- --=- =--=-
http://arcgraph.de/sr/
