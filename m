Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089Ab0GUE4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:56:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab0GUEzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BfPW6KDHgdbCEUk1UvnwQYAJWI5ucKnKhgwWBjcdNUJ006YcrXQav62ps1WxRFsLTk
         vqfbWYA/H+5W1YnPG3gtXxYo/wZXPnSvmKnjyTzhwdEkbb4P48Kk+neYO+g7Ess+heBf
         AC0y/OnVv5hu9KLFZUOrB5bRqyUfsbM0SN1rM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 72/72]Documentation/mtd/nand_ecc.txt update web address.
Date: Tue, 20 Jul 2010 21:54:53 -0700
Message-Id: <1279688096-29519-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/mtd/nand_ecc.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/mtd/nand_ecc.txt b/Documentation/mtd/nand_ecc.txt
index 274821b..990efd7 100644
--- a/Documentation/mtd/nand_ecc.txt
+++ b/Documentation/mtd/nand_ecc.txt
@@ -91,7 +91,7 @@ ECC 1   rp15  rp14  rp13  rp12  rp11  rp10  rp09  rp08
 ECC 2   cp5   cp4   cp3   cp2   cp1   cp0      1     1
 
 I detected after writing this that ST application note AN1823
-(http://www.st.com/stonline/books/pdf/docs/10123.pdf) gives a much
+(http://www.st.com/stonline/) gives a much
 nicer picture.(but they use line parity as term where I use row parity)
 Oh well, I'm graphically challenged, so suffer with me for a moment :-)
 And I could not reuse the ST picture anyway for copyright reasons.
-- 
1.7.1.rc1.21.gf3bd6

