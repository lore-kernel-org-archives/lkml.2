Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2GSMmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:42:53 -0400
Received: from sh.osrg.net ([192.16.179.4]:52949 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab2GSMmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:42:46 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 0/2] two more nilfs2 patches
Date: Thu, 19 Jul 2012 21:34:17 +0900
Message-Id: <1342701259-32314-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Thu, 19 Jul 2012 21:42:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please apply the following two patches and send them upstream at the
upcoming merge window, along with the previous patchset.

These add missing comments on structures in nilfs2.

Thanks,
Ryusuke Konishi
--

Vyacheslav Dubeyko (2):
      NILFS2: add omitted comments for structures in nilfs2_fs.h
      NILFS2: add omitted comments for different structures in driver implementation

 fs/nilfs2/alloc.h         |   14 +++++++---
 fs/nilfs2/bmap.h          |    7 +++++
 fs/nilfs2/btnode.h        |    8 +++++-
 fs/nilfs2/dat.c           |    6 +++++
 fs/nilfs2/export.h        |    8 ++++++
 fs/nilfs2/ifile.c         |    6 ++++-
 fs/nilfs2/inode.c         |    7 +++++
 fs/nilfs2/mdt.h           |    7 +++++
 fs/nilfs2/nilfs.h         |   17 ++++++++++--
 fs/nilfs2/sufile.c        |    8 +++++-
 fs/nilfs2/the_nilfs.h     |    3 +--
 include/linux/nilfs2_fs.h |   63 ++++++++++++++++++++++++++++-----------------
 12 files changed, 120 insertions(+), 34 deletions(-)

