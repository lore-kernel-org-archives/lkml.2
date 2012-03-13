Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab2CMAoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:44:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:48383 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964848Ab2CMAXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 136/196] ALSA: powermac - Fix obsoleted machine_is_compatible()
Date: Mon, 12 Mar 2012 20:20:49 -0400
Message-Id: <1331598109-31424-91-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 68c7ccb8f85801655aa681391dc0ee037a2b66d4 upstream.

machine_is_compatible() was renamed to of_machine_is_compatible().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/ppc/tumbler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/ppc/tumbler.c b/sound/ppc/tumbler.c
index 696280c..31efa21 100644
--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -47,7 +47,7 @@
 #define DBG(fmt...)
 #endif
 
-#define IS_G4DA (machine_is_compatible("PowerMac3,4"))
+#define IS_G4DA (of_machine_is_compatible("PowerMac3,4"))
 
 /* i2c address for tumbler */
 #define TAS_I2C_ADDR	0x34
-- 
1.7.9.3

