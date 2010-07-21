Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab0GUFCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:02:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51220 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557Ab0GUE7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lTdaFcCVDJBEFV3l5VIaua4w7vkUPn0i3xBo0/7p4z1lIP4/xv9MTQv9Fw5QDrPy7Y
         uHVPpcIPoxJyXSP6OzOYMn7E3lFzFaVDNXeHwtngWrUPl7oKniqw1lbosnzaE4AfBjuW
         Q71wc/YQkQ9qfo8+JgCv48yaaUjjTJaGOM1P8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 131/131]Documentation/video4linux/README.ivtv update web address.
Date: Tue, 20 Jul 2010 21:58:48 -0700
Message-Id: <1279688336-29735-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/README.ivtv |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/README.ivtv b/Documentation/video4linux/README.ivtv
index 73df22c..42b0668 100644
--- a/Documentation/video4linux/README.ivtv
+++ b/Documentation/video4linux/README.ivtv
@@ -10,7 +10,7 @@ Hauppauge PVR-350.
 NOTE: this driver requires the latest encoder firmware (version 2.06.039, size
 376836 bytes). Get the firmware from here:
 
-http://dl.ivtvdriver.org/ivtv/firmware/firmware.tar.gz
+http://dl.ivtvdriver.org/ivtv/firmware/
 
 NOTE: 'normal' TV applications do not work with this driver, you need
 an application that can handle MPEG input such as mplayer, xine, MythTV,
-- 
1.7.1.rc1.21.gf3bd6

