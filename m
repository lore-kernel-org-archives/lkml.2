Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab0GUFVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:21:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0GUEwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CK+1wng6yAbx4PpyUrt3ncXZJAykhTsxQDH+x3lhvR9jJCHmGkjab6dr0OoZHrTbuS
         nOrTsKfQ/zxwbyJLYnWnNexVfaiwGFckJkN7H+5D7+Y7tvyrKjB2frjubxjvQeZd9Se4
         s06E9JJhF2bKArl47x6ZN3fqI+rftH0pRBk6Y=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 21/21]Documentation/device-mapper/dm-crypt.txt update web address.
Date: Tue, 20 Jul 2010 21:51:57 -0700
Message-Id: <1279687926-29360-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/device-mapper/dm-crypt.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index 6680cab..524de92 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -36,7 +36,7 @@ Example scripts
 ===============
 LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
 encryption with dm-crypt using the 'cryptsetup' utility, see
-http://luks.endorphin.org/
+http://clemens.endorphin.org/cryptography
 
 [[
 #!/bin/sh
-- 
1.7.1.rc1.21.gf3bd6

