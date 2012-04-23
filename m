Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2DWWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:16:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51577 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2DWWQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:16:57 -0400
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 3/3] kbuild, deb-pkg: Update git repository URL in debian/copyright file
Date: Tue, 24 Apr 2012 00:16:29 +0200
Message-Id: <1335219389-10887-3-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335219389-10887-1-git-send-email-sedat.dilek@gmail.com>
References: <1335219389-10887-1-git-send-email-sedat.dilek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 scripts/package/builddeb |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 62c512b..aec6aee 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -204,7 +204,7 @@ ftp://ftp.kernel.org/pub/linux/kernel
 Copyright: 1991 - 2012 Linus Torvalds and others.
 
 The git repository for mainline kernel development is at:
-git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
-- 
1.7.9.5

