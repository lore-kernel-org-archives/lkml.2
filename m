Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab0IGDmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 23:42:45 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60753 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0IGDmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 23:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nT89MXd1uybwyGJhERApa+46jk6/LPTCcYWVLuicvvot9NCeZnyco5PgLRmrBcDF4s
         U/n5Fku+Dg4Y1ypbldCeuOOW1gpz8/dvQQHOEcIAVDRMLzOOFUiBXAeGVNJJ/GQ5MA67
         dq790sOrKwMwFkeoa9AhTmCE1Pnesf8uOr5Io=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4]Documentation/filesystems/affs.txt Update web address to the proper one.
Date: Mon,  6 Sep 2010 20:42:57 -0700
Message-Id: <1283830980-25750-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one missed the boat after the initial commit. Thanks to Geert Uytterhoeven
for pointing this out. So update the web address to the proper address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/filesystems/affs.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/affs.txt b/Documentation/filesystems/affs.txt
index 81ac488..7ecaf8f 100644
--- a/Documentation/filesystems/affs.txt
+++ b/Documentation/filesystems/affs.txt
@@ -216,4 +216,4 @@ due to an incompatibility with the Amiga floppy controller.
 
 If you are interested in an Amiga Emulator for Linux, look at
 
-http://web.archive.org/web/*/http://www.freiburg.linux.de/~uae/
+http://www.amigaemulator.org/
-- 
1.7.2.1

