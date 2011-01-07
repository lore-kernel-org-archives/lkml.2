Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1AGRAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:00:12 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57308 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1AGRAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:00:11 -0500
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [git pull] fuse updates for 2.6.38
Message-Id: <E1PbFfb-0001nE-HG@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 07 Jan 2011 18:00:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

to receive the following updates.

Thanks,
Miklos


Miklos Szeredi (4):
      fuse: ioctl cleanup
      fuse: separate queue for FORGET requests
      fuse: allow batching of FORGET requests
      fuse: fix ioctl ABI

---
 fs/fuse/dev.c        |  156 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/fuse/dir.c        |   53 ++++++++---------
 fs/fuse/file.c       |   66 +++++++++++++++++----
 fs/fuse/fuse_i.h     |   27 ++++++---
 fs/fuse/inode.c      |   30 ++++------
 include/linux/fuse.h |   26 ++++++++-
 6 files changed, 281 insertions(+), 77 deletions(-)
