Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab0IIWgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:36:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736Ab0IIWgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dMh8pkhhKJijH/8XMSjq4sUKQBT/Wkm5SE1eHEeXNzNBmO3YWia9vKkn7Rvwl3/Y1O
         5A13e+aBXgAdgpnlyb55YN1ACNPO4rKbiy+4Zh3rZ1W9mydy5PdA1o2NfEnCL9lMTq2a
         xZkX6k9LBQuO0TfJ050ltS6hVTpSOGAozKj4c=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 113/223]drivers/net/wan/cosa.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:42 -0700
Message-Id: <1284071809-8149-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
References: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wan/cosa.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 04c6cd4..bc8b3fa 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -28,8 +28,7 @@
  * Masaryk University (http://www.ics.muni.cz/). The hardware is
  * developed by Jiri Novotny <novotny@ics.muni.cz>. More information
  * and the photo of both cards is available at
- * http://www.pavoucek.cz/cosa.html. The card documentation, firmwares
- * and other goods can be downloaded from ftp://ftp.ics.muni.cz/pub/cosa/.
+ * http://web.archive.org/web/20010412025813/http://www.pavoucek.cz/cosa.html.
  * For Linux-specific utilities, see below in the "Software info" section.
  * If you want to order the card, contact Jiri Novotny.
  *
-- 
1.7.2.1

