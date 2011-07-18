Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1GREyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 00:54:01 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:59276 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab1GREyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 00:54:00 -0400
Message-ID: <4E23BC5F.4060200@gmail.com>
Date: Mon, 18 Jul 2011 12:53:51 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3.0-rc7] btrfs: Update git repository links for btrfs utilities
 in Documentation/filesystems/btrfs.txt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.0-rc7 kernel.

>From d22497ac8c5dd55a2ef9a47de5f2ddee55f8ec50 Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <shhuiw@gmail.com>
Date: Sun, 17 Jul 2011 21:45:01 -0500
Subject: [PATCH 3.0-rc7] btrfs: Update git repository links for btrfs utilities in Documentation/filesystems/btrfs.txt

git repository link for btrfs utilities
   http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
doesn't work, and git-clone can get failed as:
$ git clone
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
Initialized empty Git repository in
/home/crossover/dev/btrfs-progs-unstable/.git/
fatal:
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git/info/refs not found: did you run git update-server-info on the server?

Update git repository links for btrfs utilities to the latest ones
in Documentation/filesystems/btrfs.txt

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 Documentation/filesystems/btrfs.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 64087c3..b095261 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -63,8 +63,9 @@ IRC network.
 Userspace tools for creating and manipulating Btrfs file systems are
 available from the git repository at the following location:
 
- http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
+ http://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
+ https://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
 
 These include the following tools:
 
-- 
1.7.1

