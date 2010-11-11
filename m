Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0KKSJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:09:15 -0500
Received: from smtp-out-138.synserver.de ([212.40.180.138]:1030 "HELO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754651Ab0KKSJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:09:14 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27496
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] MIPS: JZ4740: Fix pcm device name
Date: Thu, 11 Nov 2010 19:08:52 +0100
Message-Id: <1289498933-12836-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part the ASoC multi-component patch (commit f0fba2ad) the jz4740 pcm driver
was renamed to 'jz4740-pcm-audio'. Adjust the device name accordingly.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/jz4740/platform.c b/arch/mips/jz4740/platform.c
index c860b01..a17a17b 100644
--- a/arch/mips/jz4740/platform.c
+++ b/arch/mips/jz4740/platform.c
@@ -208,7 +208,7 @@ struct platform_device jz4740_i2s_device = {
 
 /* PCM */
 struct platform_device jz4740_pcm_device = {
-	.name		= "jz4740-pcm",
+	.name		= "jz4740-pcm-audio",
 	.id		= -1,
 };
 
-- 
1.5.6.5

