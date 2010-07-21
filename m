Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686Ab0GUFDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:03:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51220 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762162Ab0GUE7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VlzNZq45ueqnzZH7MNX36gSaxKC/1deqX7kcSLHjTVIXW5qIuvhD85l2C1Tn+toRXf
         ljlmp+4+xZ+LV05n/QwOPz4K7DJaBIiYXglLr4V8VPhRulQr138Wix9G528JoL+Crd7c
         MZ4DCsff6nBYW4SfVpqnFI7lKG7e0YEuIKviY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 128/128]Documentation/video4linux/bttv/MAKEDEV update web address.
Date: Tue, 20 Jul 2010 21:58:45 -0700
Message-Id: <1279688336-29735-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/bttv/MAKEDEV |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/bttv/MAKEDEV b/Documentation/video4linux/bttv/MAKEDEV
index 6c29ba4..9d112f7 100644
--- a/Documentation/video4linux/bttv/MAKEDEV
+++ b/Documentation/video4linux/bttv/MAKEDEV
@@ -14,7 +14,7 @@ function makedev () {
 	ln -s /dev/${1}0 /dev/$1
 }
 
-# see http://roadrunner.swansea.uk.linux.org/v4lapi.shtml
+# see http://linux.bytesex.org/v4l2/API.html
 
 echo "*** new device names ***"
 makedev video 0
-- 
1.7.1.rc1.21.gf3bd6

