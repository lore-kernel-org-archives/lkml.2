Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab0GUFCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:02:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61571 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab0GUE72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RL4cFBmj8sYxRQp5H4i3NOtFq6DLBowrX2WAG/HteOlIluORrMRgat5nOH6EqcaWzQ
         SaT8zP+SFr1bKFEg57+RJcttkAP1dkNdoi9wcdI2UeQao8c7FcETbUXGn0/wX7oYruOe
         NhxLurhQFvLN/G+n0UyI9D1DN0NBkvUCLrPcY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 132/132]Documentation/video4linux/w9966.txt update web address.
Date: Tue, 20 Jul 2010 21:58:49 -0700
Message-Id: <1279688336-29735-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/w9966.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/w9966.txt b/Documentation/video4linux/w9966.txt
index 78a6512..8550245 100644
--- a/Documentation/video4linux/w9966.txt
+++ b/Documentation/video4linux/w9966.txt
@@ -24,7 +24,7 @@ where every two pixels take 4 bytes. In SDL (www.libsdl.org) this format
 is called VIDEO_PALETTE_YUV422 (16 bpp).
 
 A minimal test application (with source) is available from:
-  http://hem.fyristorg.com/mogul/w9966.html
+  http://www.slackwaresupport.com/howtos/Webcam-HOWTO
 
 The slow framerate is due to missing DMA ECP read support in the
 parport drivers. I might add working EPP support later.
-- 
1.7.1.rc1.21.gf3bd6

