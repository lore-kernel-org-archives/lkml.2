Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1B0QEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:04:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:58526 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab1B0QBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:01:39 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 05/17] unicore32: ADD MAINTAINER for unicore32 architecture
Date: Sun, 27 Feb 2011 15:59:33 +0000
Message-Id: <c8dc614a353b6653975877055f780e9cb47ca29c.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

Add MAINTAINER list for unicore32 architecture and pkunity soc drivers.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5dd6c75..a175ec4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4882,6 +4882,13 @@ S:	Maintained
 F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
 
+PKUNITY SOC DRIVERS
+M:	Guan Xuetao <gxt@mprc.pku.edu.cn>
+W:	http://mprc.pku.edu.cn/~guanxuetao/linux
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
+F:	drivers/input/serio/i8042-unicore32io.h
+
 PMC SIERRA MaxRAID DRIVER
 M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
 L:	linux-scsi@vger.kernel.org
@@ -6245,6 +6252,13 @@ F:	drivers/uwb/
 F:	include/linux/uwb.h
 F:	include/linux/uwb/
 
+UNICORE32 ARCHITECTURE:
+M:	Guan Xuetao <gxt@mprc.pku.edu.cn>
+W:	http://mprc.pku.edu.cn/~guanxuetao/linux
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
+F:	arch/unicore32/
+
 UNIFDEF
 M:	Tony Finch <dot@dotat.at>
 W:	http://dotat.at/prog/unifdef
-- 
1.7.4.1

