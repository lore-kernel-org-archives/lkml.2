Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1GURQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:16:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34612 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1GURQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:16:34 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/4] drivers/base/devtmpfs.c: fix uninitialized variable
Date: Thu, 21 Jul 2011 13:16:21 -0400
Message-Id: <1311268581-20405-4-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1311268581-20405-1-git-send-email-lacombar@gmail.com>
References: <1311268581-20405-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/base/devtmpfs.c: In function 'create_path':
drivers/base/devtmpfs.c:169:6: warning: 'err' may be used uninitialized in this function

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 drivers/base/devtmpfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 38e6464..256c78a 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -166,7 +166,7 @@ static int create_path(const char *nodepath)
 {
 	char *path;
 	char *s;
-	int err;
+	int err = 0;
 
 	/* parent directories do not exist, create them */
 	path = kstrdup(nodepath, GFP_KERNEL);
-- 
1.7.6.153.g78432

