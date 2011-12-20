Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1LTUae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:30:34 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43324 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1LTUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:30:29 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 20 Dec 2011 21:30:17 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Carl Karsten <carl@personnelware.com>
Subject: [PATCH 0/3] firewire: some simple kernel log changes
Message-ID: <20111220213017.75ff380c@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wanted to hold off with posting the following few patches because I still
want to add some firewire-core and firewire-net logging related updates as
well.  But since Carl may be interested in patch 2/3 right now, here they are.

1/3 firewire: do not expose globally unique IDs in the kernel log
2/3 firewire: ohci: use dev_printk API
3/3 firewire: sbp2: use dev_printk API

 drivers/firewire/core-device.c |    8 -
 drivers/firewire/net.c         |    8 -
 drivers/firewire/ohci.c        |  185 +++++++++++++++++++++++------------------
 drivers/firewire/sbp2.c        |   93 +++++++++++---------
 4 files changed, 165 insertions(+), 129 deletions(-)
-- 
Stefan Richter
-=====-==-== ==-- =-=--
http://arcgraph.de/sr/
