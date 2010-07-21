Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664Ab0GUFQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:16:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35617 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab0GUExr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MnEtFl5OSqV5xj70tb+XUXOOXXNbRzl+gIFtXTxDnK93RqaO4e3OhGLjKfS/CXeTrP
         BtbFmzmtUW0KOrf59Q6hL/aNhWmSKteZNczilWvI8LTKXVWt0i79IOR6G8n9Iyu7ZYZM
         AHKIR5FOPzpxKwMaGP8T/Z9X3Lbci8/9NaeWc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 46/46]Documentation/hwmon/g760a update web address.
Date: Tue, 20 Jul 2010 21:53:45 -0700
Message-Id: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates th ebroken web address to the company site
due to me not knowing where this is.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/g760a |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/g760a b/Documentation/hwmon/g760a
index e032eeb..8924bd8 100644
--- a/Documentation/hwmon/g760a
+++ b/Documentation/hwmon/g760a
@@ -5,7 +5,7 @@ Supported chips:
   * Global Mixed-mode Technology Inc. G760A
     Prefix: 'g760a'
     Datasheet: Publicly available at the GMT website
-      http://www.gmt.com.tw/datasheet/g760a.pdf
+      http://www.gmt.com.tw/
 
 Author: Herbert Valerio Riedel <hvr@gnu.org>
 
-- 
1.7.1.rc1.21.gf3bd6

