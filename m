Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab1CVNFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:05:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51857 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab1CVNFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:05:19 -0400
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [GIT PULL] fuse updates for 2.6.39
Message-Id: <E1Q21Gt-0008IX-Ah@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Mar 2011 14:05:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

to receive the following fuse updates.

Thanks,
Miklos
----


Bryan Green (1):
      fuse: wakeup pollers on connection release/abort

Miklos Szeredi (3):
      fuse: reduce size of struct fuse_request
      fuse: make fuse_permission() RCU aware
      fuse: make fuse_dentry_revalidate() RCU aware

---
 fs/fuse/cuse.c   |   12 ++++++++++--
 fs/fuse/dev.c    |   17 +++++++++++++++++
 fs/fuse/dir.c    |   38 ++++++++++++++++++++++++++------------
 fs/fuse/file.c   |    2 +-
 fs/fuse/fuse_i.h |    1 -
 5 files changed, 54 insertions(+), 16 deletions(-)
