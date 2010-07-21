Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762157Ab0GUEyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:54:49 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762102Ab0GUEyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gyzdeQTnJ6TsNCH9dx0t0NyKiuOPBWcXWgqsaMfBUbO0TT7yQqDHrCy0pMqlAVL9Yj
         vPbOdVsD8V4etgP1C30boDnkHZPBMmFGMnS8ISG1b/ndzXeeeT3Fwta1K9lXHTT4VyP2
         4r5H4U9l8bTDACww6WDB7rXDl/RaNMYAA02K0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 52/52]Documentation/ia64/aliasing.txt update web address.
Date: Tue, 20 Jul 2010 21:53:51 -0700
Message-Id: <1279688039-29465-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unused web address.
I have no idea where this is.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/ia64/aliasing.txt |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/ia64/aliasing.txt b/Documentation/ia64/aliasing.txt
index aa3e953..5a4dea6 100644
--- a/Documentation/ia64/aliasing.txt
+++ b/Documentation/ia64/aliasing.txt
@@ -168,8 +168,6 @@ PAST PROBLEM CASES
 
     mmap of 0x0-0x9FFFF /dev/mem by "hwinfo" on HP sx1000 with VGA enabled
 
-      See https://bugzilla.novell.com/show_bug.cgi?id=140858.
-
       The EFI memory map reports the following attributes:
         0x00000-0x9FFFF WB only
         0xA0000-0xBFFFF UC only (VGA frame buffer)
-- 
1.7.1.rc1.21.gf3bd6

