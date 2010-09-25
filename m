Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab0IYSdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 14:33:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54221 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0IYSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 14:33:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u37yl7bY5Kg64CjpnBbr1uK3jo2uXScP1HbzQ3Jz64vLlF76+dmbuJQMmP89OClRRb
         U9ADkHC0s4S0HcIdDMG9SeAYOndSTMLTO02bb4Nn33MeK0S1Yn9RYIInlSFcDfje7m7X
         uQ0QASj6cAWAi0oUbKO+jm3xlC01ScvgJcpaw=
From: Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
        sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 08/10] Fs: ext4: ioctl: fixed spacing issue
Date: Sat, 25 Sep 2010 14:31:59 -0400
Message-Id: <1285439521-2557-8-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tracey Dent <Tdent48227@gmail.com>

Fixed spaceing issues using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bf5ae88..4e3ed22 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -200,7 +200,7 @@ setversion_out:
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -269,7 +269,7 @@ mext_out:
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
-- 
1.7.3

