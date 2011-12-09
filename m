Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1LIEXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:23:15 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44365 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753653Ab1LIEXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:23:10 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tobias Ringstrom <tori@unhappy.mine.nu>,
        Grant Grundler <grundler@parisc-linux.org>,
        David Davies <davies@maniac.ultranet.com>
Subject: [PATCH v3.2 08/10] MAINTAINERS: Update tulip F: patterns
Date: Thu,  8 Dec 2011 20:21:46 -0800
Message-Id: <38c134f7b555bf732550884366991391d35bb229.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a88394cfb58 ("ewrk3/tulip: Move the DEC - Tulip drivers")
moved the files, update the patterns.

CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Tobias Ringstrom <tori@unhappy.mine.nu>
CC: Grant Grundler <grundler@parisc-linux.org>
CC: David Davies <davies@maniac.ultranet.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d7a279f..9926225 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2115,7 +2115,7 @@ DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
 L:	netdev@vger.kernel.org
 S:	Orphan
 F:	Documentation/networking/dmfe.txt
-F:	drivers/net/ethernet/tulip/dmfe.c
+F:	drivers/net/ethernet/dec/tulip/dmfe.c
 
 DC390/AM53C974 SCSI driver
 M:	Kurt Garloff <garloff@suse.de>
@@ -6655,7 +6655,7 @@ TULIP NETWORK DRIVERS
 M:	Grant Grundler <grundler@parisc-linux.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/ethernet/tulip/
+F:	drivers/net/ethernet/dec/tulip/
 
 TUN/TAP driver
 M:	Maxim Krasnyansky <maxk@qualcomm.com>
-- 
1.7.8.111.gad25c.dirty

