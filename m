Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab0IIWeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:34:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43866 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab0IIWet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nVnZ/5+YtY1c9/i973eV8OrKWBwwhIQKM1zhR2gc9iNRFbQ4UGJsYheoY6GzAQUReH
         i9ks0yG9SeugVHWV0aZmrad2l+w3eByNBfPwnwdIgHnTZsLkl2I+R1DX+o9gd4H2wPHJ
         9hfkfxMVBZITjC8nPGGWPCtapOsF4P14P5Bok=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 103/223]drivers/net/tokenring/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:35:01 -0700
Message-Id: <1284071703-7996-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071703-7996-1-git-send-email-justinmattock@gmail.com>
References: <1284071703-7996-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/tokenring/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tokenring/Kconfig b/drivers/net/tokenring/Kconfig
index c4137b0..d490b50 100644
--- a/drivers/net/tokenring/Kconfig
+++ b/drivers/net/tokenring/Kconfig
@@ -100,8 +100,7 @@ config TMS380TR
 	  read the Token-Ring mini-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  Also read the file <file:Documentation/networking/tms380tr.txt> or
-	  check <http://www.auk.cx/tms380tr/>.
+	  Also read the file <file:Documentation/networking/tms380tr.txt>
 
 	  To compile this driver as a module, choose M here: the module will be
 	  called tms380tr.
-- 
1.7.2.1

