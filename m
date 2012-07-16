Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2GPBaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 21:30:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:45161 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab2GPBaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 21:30:19 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org
Subject: [PATCH 0/4] some nilfs2 fixes
Date: Mon, 16 Jul 2012 10:05:22 +0900
Message-Id: <1342400726-30670-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Mon, 16 Jul 2012 10:30:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please apply the following patches and send them upstream via the -mm
tree at the next merge window.

This patchset is composed of two comment fixes and two ioctl-related
fixes in which one is for a deadlock issue and another for a potential
timing issue.

Thanks,
Ryusuke Konishi
--

Fernando Luis Vazquez Cao (1):
      NILFS2: remove references to long gone super operations

Ryusuke Konishi (2):
      nilfs2: fix timing issue between rmcp and chcp ioctls
      nilfs2: fix deadlock issue between chcp and thaw ioctls

Vyacheslav Dubeyko (1):
      nilfs2: add omitted comment for ns_mount_state field of the_nilfs structure

 fs/nilfs2/cpfile.c    |   10 +++++++---
 fs/nilfs2/ioctl.c     |    4 ++--
 fs/nilfs2/super.c     |    6 +++---
 fs/nilfs2/the_nilfs.c |    1 +
 fs/nilfs2/the_nilfs.h |    3 +++
 5 files changed, 16 insertions(+), 8 deletions(-)

