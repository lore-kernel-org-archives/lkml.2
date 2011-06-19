Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1FSLp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:45:59 -0400
Received: from mail.southpole.se ([193.12.106.18]:37744 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1FSLpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:33 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 19/19] OpenRISC: Add MAINTAINERS entry
Date: Sun, 19 Jun 2011 13:43:45 +0200
Message-Id: <1308483825-6023-20-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29801f7..12e2ef4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4668,6 +4668,14 @@ F:	drivers/of
 F:	include/linux/of*.h
 K:	of_get_property
 
+OPENRISC ARCHITECTURE
+M:	Jonas Bonn <jonas@southpole.se>
+W:	http://openrisc.net
+L:	linux@lists.openrisc.net
+S:	Maintained
+T:	git git://openrisc.net/~jonas/linux
+F:	arch/openrisc
+
 OPL4 DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
1.7.4.1

