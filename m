Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2H2U6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 16:58:04 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:37335 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2H2U6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 16:58:01 -0400
Date: Fri, 26 Sep 2008 17:50:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Jiri Kosina <trivial@kernel.org>
cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH][trivial] gen_init_cpio: remove redundant empty line
Message-ID: <alpine.LNX.2.00.0809261748150.6714@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a completely trivial patch to remove a completely redundant blank
line from usr/gen_init_cpio.c

Signed-off-by: Jesper Juhl <jj@codesealer.com>
---
 usr/gen_init_cpio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index af0f22f..b2e46bc 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -402,7 +402,6 @@ static char *cpio_replace_env(char *new_location)
        return new_location;
 }
 
-
 static int cpio_mkfile_line(const char *line)
 {
 	char name[PATH_MAX + 1];
-- 
1.7.12


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

