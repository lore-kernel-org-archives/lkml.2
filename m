Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0HNQnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 12:43:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56959 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563Ab0HNQnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 12:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bPxF2T6VAjwrDKSrPrQ2CrTDG7beEjyej65E8Ha+6KYs2qMovWLbmIUxsCHCQPyLkk
         u06zscL8JYxlz2QeklK77EPp4/fahnLodXSCEom4nCrJrXg2yMS2w0/hne1TK58g8Zkr
         DM04Gd3qTgKnKcs2N4SFhmNCvU3GbAIx8ibaE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/2]include/video/vga.h update web address.
Date: Sat, 14 Aug 2010 09:43:22 -0700
Message-Id: <1281804202-27500-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1281804202-27500-1-git-send-email-justinmattock@gmail.com>
References: <1281804202-27500-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below updates a broken web address to one(hopefully) thats 
the new correct address.(if not let me know, and ill resend)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/video/vga.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/video/vga.h b/include/video/vga.h
index b49a512..2b8691f 100644
--- a/include/video/vga.h
+++ b/include/video/vga.h
@@ -5,7 +5,7 @@
  * 
  * Copyright history from vga16fb.c:
  *	Copyright 1999 Ben Pfaff and Petr Vandrovec
- *	Based on VGA info at http://www.goodnet.com/~tinara/FreeVGA/home.htm
+ *	Based on VGA info at http://www.osdever.net/FreeVGA/home.htm 
  *	Based on VESA framebuffer (c) 1998 Gerd Knorr
  *
  * This file is subject to the terms and conditions of the GNU General
-- 
1.7.1.rc1.21.gf3bd6

