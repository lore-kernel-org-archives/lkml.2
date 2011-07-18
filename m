Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1GRH1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 03:27:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50926 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1GRH1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 03:27:03 -0400
Message-ID: <4E23E040.6040408@gmail.com>
Date: Mon, 18 Jul 2011 15:26:56 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] btrfs-progs-unstable: replace debug-tree to btrfs-debug-tree
 in INSTALL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c04da1655df6d75db834ddbd3a3b4a58a0d9a0c9 Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <shhuiw@gmail.com>
Date: Mon, 18 Jul 2011 02:17:31 -0500
Subject: [PATCH] btrfs-progs-unstable: replace debug-tree to btrfs-debug-tree in INSTALL

debug-tree doesn't exist after btrfs-progs installed.
Use btrfs-debug-tree to print FS metadata in text form,
not debug-tree.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 INSTALL |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/INSTALL b/INSTALL
index 16b45a5..2db6d27 100644
--- a/INSTALL
+++ b/INSTALL
@@ -42,7 +42,7 @@ btrfsctl: control program to create snapshots and subvolumes:
 
 btrfsck: do a limited check of the FS extent trees.</li>
 
-debug-tree: print all of the FS metadata in text form.  Example:
+btrfs-debug-tree: print all of the FS metadata in text form.  Example:
 
-	debug-tree /dev/sda2 >& big_output_file
+	btrfs-debug-tree /dev/sda2 >& big_output_file
 
-- 
1.7.1

