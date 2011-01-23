Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab1AWEQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 23:16:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27423 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1AWEQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 23:16:55 -0500
Date: Sat, 22 Jan 2011 20:16:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Cc: Linus <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] rapidio: fix new kernel-doc warnings
Message-Id: <20110122201612.dc7b1011.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new rapidio kernel-doc warnings:

Warning(drivers/rapidio/rio-scan.c:953): No description found for parameter 'prev'
Warning(drivers/rapidio/rio-scan.c:953): No description found for parameter 'prev_port'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
---
 drivers/rapidio/rio-scan.c |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-2638-rc2.orig/drivers/rapidio/rio-scan.c
+++ lnx-2638-rc2/drivers/rapidio/rio-scan.c
@@ -943,6 +943,8 @@ static int rio_enum_complete(struct rio_
  * @port: Master port to send transactions
  * @destid: Current destination ID in network
  * @hopcount: Number of hops into the network
+ * @prev: previous rio_dev
+ * @prev_port: previous port number
  *
  * Recursively discovers a RIO network.  Transactions are sent via the
  * master port passed in @port.
