Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1GQPKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:10:35 -0400
Received: from mail.southpole.se ([193.12.106.18]:34892 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab1GQPJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:09:40 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v3 19/19] OpenRISC: Add MAINTAINERS entry
Date: Sun, 17 Jul 2011 17:08:29 +0200
Message-Id: <a9b7d9757f9331893998332d282270185ce29a9e.1310913472.git.jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
In-Reply-To: <cover.1310913472.git.jonas@southpole.se>
References: <cover.1310913472.git.jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f0358cd..dd1492a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4670,6 +4670,14 @@ F:	drivers/of
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

