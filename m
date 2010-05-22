Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0EVRkv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 13:40:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50044 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab0EVRku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 13:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=tZUzyKxliXme1tiNz1XkEevKYZVH09OPEV1f8I7F60zYZQCvMtbQxuTlK2nqAYSrsN
         n9AYCIpMwvzDYLrgk+M6bbOTi3/nwdzZaY1Z8qq+L4yHXv475J9JD5WIpwo5kpEd+mce
         gmRTnh7eI/11vZZTnjr3IjsN9nlRcpIGFGgi4=
MIME-Version: 1.0
Date: Sat, 22 May 2010 12:40:48 -0500
Message-ID: <AANLkTilzm9jrQpBGxqhwFt-BqB04-dYEBQmdNpb5Xb15@mail.gmail.com>
Subject: [GIT PULL] 9p file system changes for merge window
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d515e86e639890b33a09390d062b0831664f04a2:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../jack/linux-udf-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (1):
      fs/9p: Make sure we properly instantiate dentry.

Dan Carpenter (1):
      9p: cleanup: remove unneeded assignment

Sripathi Kodi (4):
      9p: VFS switches for 9p2000.L: protocol and client changes
      9p: VFS switches for 9p2000.L: VFS switches
      9p: add 9P2000.L statfs operation
      9p: add 9P2000.L rename operation

Venkateswararao Jujjuri (2):
      9p: Add mksock support
      9p: Optimize TCREATE by eliminating a redundant fid clone.

 fs/9p/v9fs_vfs.h        |    2 +
 fs/9p/vfs_dir.c         |    8 ++++
 fs/9p/vfs_file.c        |   11 +++++
 fs/9p/vfs_inode.c       |  107 ++++++++++++++++++++++++++++++++++------------
 fs/9p/vfs_super.c       |   55 +++++++++++++++++++++++-
 include/net/9p/9p.h     |   33 ++++++++++++++
 include/net/9p/client.h |    2 +
 net/9p/client.c         |   70 ++++++++++++++++++++++++++++++-
 net/9p/protocol.c       |    6 ++-
 9 files changed, 261 insertions(+), 33 deletions(-)

    Thanks,
         -eric
