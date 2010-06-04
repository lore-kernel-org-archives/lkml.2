Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0FDVzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:55:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64864 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab0FDVzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:55:06 -0400
Subject: [PATCH] maintainers: Add git trees for SPI and device tree
To: joe@perches.com, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 04 Jun 2010 15:55:02 -0600
Message-ID: <20100604215502.12996.62845.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2652ebc..1b2d7b6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4216,6 +4216,7 @@ OPEN FIRMWARE AND FLATTENED DEVICE TREE
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	devicetree-discuss@lists.ozlabs.org
 W:	http://fdt.secretlab.ca
+T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 F:	drivers/of
 F:	include/linux/of*.h
@@ -5388,6 +5389,7 @@ M:	David Brownell <dbrownell@users.sourceforge.net>
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	spi-devel-general@lists.sourceforge.net
 Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
+T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 F:	Documentation/spi/
 F:	drivers/spi/

