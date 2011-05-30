Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab1E3Nww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:52:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33187 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1E3Nwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gF2hpNGBy6w5vll28l5Y0NNQ2dHSVVD1ai+BMRFgLvZ2Fioc5loMY3aA6FM9af1JzR
         DHvF+rLISoESl5GEVa3rvLrueABaAb4lNYrl2ks3oTiEYa9l43lXviYNtxEka10delJv
         pMMeOAz0ULyWA1IuKgAMhd5dx7eVIVN2+0LDg=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] FS:remove the spare space in super.c
Date: Mon, 30 May 2011 21:52:19 +0800
Message-Id: <1306763539-3932-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the spare space in super.c.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 fs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index c755939..dc2d5f7 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -521,7 +521,7 @@ restart:
 	spin_unlock(&sb_lock);
 	return NULL;
 }
- 
+
 struct super_block *user_get_super(dev_t dev)
 {
 	struct super_block *sb;
-- 
1.7.4.1

