Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0IMUQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:16:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64733 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab0IMUQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NCJPFRiZwHyhNMsizH3PvD/sRRyo/Y2wczmZYenMBpMtWUTZ0I6LfD/70jZ80L1RdT
         tBC0QJbOGiBR/siQTPMW4qow47C9A9ht77UKUAaHicxVaZ03q1cv7jA1LHMf5Dwlv1hZ
         BNKhI8umMEy6zhO3R4A7TYs5L5XFu/HAeTeGA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        clemens@ladisch.de, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/3 v2]sound/oss/ac97_codec.c Update broken web addresses.
Date: Mon, 13 Sep 2010 13:17:01 -0700
Message-Id: <1284409023-4419-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend from the original, due to Clemens Ladisch providing
the right locations of the *.pdf's etc..
 
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 sound/oss/ac97_codec.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/sound/oss/ac97_codec.c b/sound/oss/ac97_codec.c
index 456a1b4..e2c5fe9 100644
--- a/sound/oss/ac97_codec.c
+++ b/sound/oss/ac97_codec.c
@@ -22,10 +22,7 @@
  **************************************************************************
  *
  * The Intel Audio Codec '97 specification is available at the Intel
- * audio homepage: http://developer.intel.com/ial/scalableplatforms/audio/
- *
- * The specification itself is currently available at:
- * ftp://download.intel.com/ial/scalableplatforms/ac97r22.pdf
+ * http://download.intel.com/support/motherboards/desktop/sb/ac97_r23.pdf
  *
  **************************************************************************
  *
-- 
1.7.2.1

