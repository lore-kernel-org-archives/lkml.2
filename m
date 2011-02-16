Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab1BPHxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:53:25 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:42716 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab1BPHxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:53:21 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 12/12] unicore32: ADD MAINTAINER for unicore32 architecture
Date: Wed, 16 Feb 2011 15:53:15 +0800
Message-ID: <015901cbcdae$91249b10$b36dd130$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNro3HCMrtnLmwQnWB7Xl+gR1xcw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <2a84029a9974372448e55cc9e556f97acab2e438.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sun, 16 Jan 2011 00:35:49 +0800

Add MAINTAINER list for unicore32 architecture and pkunity soc drivers.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 MAINTAINERS |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7585e9d..b87a39b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4665,6 +4665,13 @@ S:	Maintained
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
@@ -6016,6 +6023,13 @@ F:	drivers/uwb/
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
1.6.2.2


