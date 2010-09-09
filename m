Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0IIW0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:26:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab0IIW0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GL+iWRycoKqNQpsifaAbgW4DR60Bm/X4gDQm9Sgk0KeYGg5vvekUDfEnoqEvWzU+eV
         ZU0GmTXfjS0KqsI72k5x2Au/9NpQbULRQGf9jgyq4pt1izaPgpvKwKNerBrgd9lYUW2e
         s0EFdSZNDPvtViqbFaUzdtGMp91bn6U+ynZBU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 035/223]drivers/input/mouse/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:26:35 -0700
Message-Id: <1284071205-7756-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/input/mouse/Kconfig |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index c714ca2..a29a870 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -27,10 +27,7 @@ config MOUSE_PS2
 
 	  Synaptics, ALPS or Elantech TouchPad users might be interested
 	  in a specialized Xorg/XFree86 driver at:
-		<http://w1.894.telia.com/~u89404340/touchpad/index.html>
-	  and a new version of GPM at:
-		<http://www.geocities.com/dt_or/gpm/gpm.html>
-	  to take advantage of the advanced features of the touchpad.
+		<http://cgit.freedesktop.org/xorg/driver/xf86-input-synaptics/>
 
 	  If unsure, say Y.
 
-- 
1.7.2.1

