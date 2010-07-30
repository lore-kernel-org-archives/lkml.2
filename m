Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab0G3Snq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:43:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39531 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404Ab0G3Snm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 14:43:42 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: Michal Marek <mmarek@suse.cz>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Christoph Hellwig <hch@lst.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix a typo in a filename
Date: Fri, 30 Jul 2010 20:43:20 +0200
Message-Id: <1280515401-13610-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 scripts/Makefile.modpost |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 8f14c81..82a2420 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -30,7 +30,7 @@
 #     - See include/linux/module.h for more details
 
 # Step 4 is solely used to allow module versioning in external modules,
-# where the CRC of each module is retrieved from the Module.symers file.
+# where the CRC of each module is retrieved from the Module.symvers file.
 
 # KBUILD_MODPOST_WARN can be set to avoid error out in case of undefined
 # symbols in the final module linking stage
-- 
1.7.1

