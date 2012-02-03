Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2BCIDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:03:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62162 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab2BCIDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:03:53 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [Patch] cris: select GENERIC_ATOMIC64
Date: Fri,  3 Feb 2012 16:03:34 +0800
Message-Id: <1328256214-18772-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cris doesn't implement atomic64 operations neither,
should select GENERIC_ATOMIC64.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index b3abfb0..1d2b611 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -49,6 +49,7 @@ config CRIS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
+	select GENERIC_ATOMIC64
 
 config HZ
 	int
