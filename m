Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab2CVJxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:53:24 -0400
Received: from msa101.auone-net.jp ([61.117.18.161]:59009 "EHLO
	msa101.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2CVJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:53:19 -0400
Date: Thu, 22 Mar 2012 18:53:17 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] deb-pkg: Update git repository URL
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20120322095318.272823E403B@msa101.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 scripts/package/builddeb |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 3c6c0b1..335ec15 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -186,7 +186,7 @@ ftp://ftp.kernel.org/pub/linux/kernel
 Copyright: 1991 - 2009 Linus Torvalds and others.
 
 The git repository for mainline kernel development is at:
-git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
-- 
1.7.9.1

