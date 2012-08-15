Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2HOUSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:18:55 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62960 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab2HOTvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:01 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 088/165] ASoC: ak4535: fixup cache register table
Date: Wed, 15 Aug 2012 15:47:12 -0400
Message-ID: <1345060109-9187-89-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7c04241acbdaf97f1448dcccd27ea0fcd1a57684 upstream.

ak4535_reg should be 8bit, but cache table is defined as 16bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/soc/codecs/ak4535.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index 352d1d0..133d8f5 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -41,11 +41,11 @@ struct ak4535_priv {
 /*
  * ak4535 register cache
  */
-static const u16 ak4535_reg[AK4535_CACHEREGNUM] = {
-    0x0000, 0x0080, 0x0000, 0x0003,
-    0x0002, 0x0000, 0x0011, 0x0001,
-    0x0000, 0x0040, 0x0036, 0x0010,
-    0x0000, 0x0000, 0x0057, 0x0000,
+static const u8 ak4535_reg[AK4535_CACHEREGNUM] = {
+	0x00, 0x80, 0x00, 0x03,
+	0x02, 0x00, 0x11, 0x01,
+	0x00, 0x40, 0x36, 0x10,
+	0x00, 0x00, 0x57, 0x00,
 };
 
 /*
-- 
1.7.12.rc2

