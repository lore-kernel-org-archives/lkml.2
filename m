Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab1EYOiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:38:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46142 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1EYOiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=KBIm+gMJRWH61xQ2k3XRf3kvmVhyqV05B+n3pW09frpMhBzUTGbaAzcy7/izy/TesQ
         Yc/RNkhQuCm8YUbJ/DfVDa//sEfNMZeK9gRmWX3fngdNSZU49leWgyr92YtCgEMDtnLA
         SbbKcyQ58pIVcqLQJyTOlTPvf5mLURQKC4Rfo=
MIME-Version: 1.0
Date: Wed, 25 May 2011 09:38:22 -0500
Message-ID: <BANLkTik97bTogQoRcsaBKxFTeGSxxySNsQ@mail.gmail.com>
Subject: [GIT PULL] 9p changes for 2.6.40 merge window
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4a7df24ddc7097cd789a7527187826552ea0765e:

  Merge branch 'for-linus/2640/i2c' of
git://git.fluff.org/bjdooks/linux (2011-05-24 16:39:23 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (2):
      fs/9p: Don't clunk dentry fid when we fail to get a writeback inode
      net/9p: p9_idpool_get return -1 on error

Eric Van Hensbergen (2):
      9p: remove experimental tag from tested configurations
      9p: update Documentation pointers

Rob Landley (3):
      net/9p: Change linuxdoc names to match functions.
      9p: typo fixes and minor cleanups
      net/9p: enable 9p to work in non-default network namespace

Sasha Levin (1):
      9p: Small cleanup in <net/9p/9p.h>

 Documentation/filesystems/9p.txt |   29 ++++++++++-------------------
 fs/9p/Kconfig                    |    5 ++---
 fs/9p/vfs_inode_dotl.c           |   11 ++++++-----
 include/net/9p/9p.h              |   13 ++++++-------
 include/net/9p/client.h          |    2 +-
 include/net/9p/transport.h       |    3 ++-
 net/9p/Kconfig                   |    8 ++++----
 net/9p/client.c                  |   30 +++++++++++++++++-------------
 net/9p/mod.c                     |    4 ++--
 net/9p/trans_fd.c                |    7 ++++---
 net/9p/util.c                    |    2 +-
 11 files changed, 55 insertions(+), 59 deletions(-)
