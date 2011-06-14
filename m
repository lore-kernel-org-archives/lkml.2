Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1FNC0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 22:26:25 -0400
Received: from mail.perches.com ([173.55.12.10]:2922 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab1FNC0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 22:26:23 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Update EBTABLES mailing list
Date: Mon, 13 Jun 2011 19:26:22 -0700
Message-Id: <733408f03604412fb9da48b0b68a0b76178cbd98.1308018319.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It moved to netfilter-devel@vger.kernel.org.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29801f7..825393f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2292,8 +2292,7 @@ F:	drivers/scsi/eata_pio.*
 
 EBTABLES
 M:	Bart De Schuymer <bart.de.schuymer@pandora.be>
-L:	ebtables-user@lists.sourceforge.net
-L:	ebtables-devel@lists.sourceforge.net
+L:	netfilter-devel@vger.kernel.org
 W:	http://ebtables.sourceforge.net/
 S:	Maintained
 F:	include/linux/netfilter_bridge/ebt_*.h
-- 
1.7.6.rc0

