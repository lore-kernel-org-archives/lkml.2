Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1LTUXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:23:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43280 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1LTUXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:23:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 20 Dec 2011 21:23:28 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: firewire git URL update
Message-ID: <20111220212328.782a55f5@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
The old URL went away when git.kernel.org was taken offline, and the new URL has
been in use and been pulled into linux-next since November.

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/MAINTAINERS
===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2621,7 +2621,7 @@ FIREWIRE SUBSYSTEM
 M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://ieee1394.wiki.kernel.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git
 S:	Maintained
 F:	drivers/firewire/
 F:	include/linux/firewire*.h


-- 
Stefan Richter
-=====-==-== ==-- =-=--
http://arcgraph.de/sr/
