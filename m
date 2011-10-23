Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab1JWP1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 11:27:47 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57427 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1JWP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 11:27:46 -0400
Subject: [PATCH] [TRIVIAL] snd-aoa: remove commented out Kconfig entry
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Oct 2011 17:24:31 +0200
Message-ID: <1319383471.6286.7.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config SND_AOA_TOPAZ has been commented out since it was added five
years ago with commit f3d9478b ("[...] add snd-aoa"). There's no
indication why it's commented out. It might as well be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
"git grep" tested only.

 sound/aoa/codecs/Kconfig |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/sound/aoa/codecs/Kconfig b/sound/aoa/codecs/Kconfig
index 808eb11..0c68e32 100644
--- a/sound/aoa/codecs/Kconfig
+++ b/sound/aoa/codecs/Kconfig
@@ -7,14 +7,6 @@ config SND_AOA_ONYX
 	codec chip found in the latest Apple machines
 	(most of those with digital audio output).
 
-#config SND_AOA_TOPAZ
-#	tristate "support Topaz chips"
-#	---help---
-#	This option enables support for the Topaz (CS84xx)
-#	codec chips found in the latest Apple machines,
-#	these chips do the digital input and output on
-#	some PowerMacs.
-
 config SND_AOA_TAS
 	tristate "support TAS chips"
 	select I2C
-- 
1.7.4.4




