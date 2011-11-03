Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1KCSJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:09:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44120 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab1KCSJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:09:38 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] MAINTAINERS: add an entry for the PHC code
Date: Thu,  3 Nov 2011 19:09:39 +0100
Message-Id: <28b8437d1db3b23318b1cc1a11baded689bab3b9.1320342956.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some months ago, tglx asked me off list if I would maintain the PTP
Hardware Clock code. Since then, the code has been fully merged, and I
am actively looking after it. This patch makes it official.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cb8c51..e74b8ebb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5254,6 +5254,17 @@ L:	cbe-oss-dev@lists.ozlabs.org
 S:	Maintained
 F:	drivers/block/ps3vram.c
 
+PTP HARDWARE CLOCK SUPPORT
+M:	Richard Cochran <richardcochran@gmail.com>
+S:	Maintained
+W:	http://linuxptp.sourceforge.net/
+F:	Documentation/ABI/testing/sysfs-ptp
+F:	Documentation/ptp/*
+F:	drivers/net/gianfar_ptp.c
+F:	drivers/net/phy/dp83640*
+F:	drivers/ptp/*
+F:	include/linux/ptp_cl*
+
 PTRACE SUPPORT
 M:	Roland McGrath <roland@redhat.com>
 M:	Oleg Nesterov <oleg@redhat.com>
-- 
1.7.2.5

