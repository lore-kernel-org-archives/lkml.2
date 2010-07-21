Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0GUE5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:57:34 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762229Ab0GUE4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=svDMDDlgamWL9OwRIrrlbS63mWDV2G2YJYwoacxQKhlMJLoTOyuA0grSlWU5dnE4g3
         zIQPSLjLeJPtLiYsnqJQEdD3A4NhGYq9sDtz7SZ6bMnYIQVaS+xa6RH6vZw8G84R8Hwb
         LyJiOQqjghxjzdo5wpDkLFFHYCgfU7cxpMDbE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 86/86]Documentation/networking/README.sb1000 update web address.
Date: Tue, 20 Jul 2010 21:55:49 -0700
Message-Id: <1279688153-29571-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes a web address due to not being able
to find anything in the vacinity.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/README.sb1000 |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/README.sb1000 b/Documentation/networking/README.sb1000
index f82d425..2c806e2 100644
--- a/Documentation/networking/README.sb1000
+++ b/Documentation/networking/README.sb1000
@@ -24,12 +24,6 @@ cable modem easy.
 
       http://www.jacksonville.net/~fventuri/
 
-   in Franco's original source code distribution .tar.gz file.  Support for
-   the sb1000 driver can be found at:
-
-      http://home.adelphia.net/~siglercm/sb1000.html
-      http://linuxpower.cx/~cable/
-
    along with these utilities.
 
 3.) The standard isapnp tools.  These are necessary to configure your SB1000
-- 
1.7.1.rc1.21.gf3bd6

