Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab2AJVBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 16:01:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33379 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab2AJVBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 16:01:13 -0500
MIME-Version: 1.0
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Tue, 10 Jan 2012 15:00:51 -0600
Message-ID: <CAFkjPTmu2AG2z64u5-=irhUMT+zARgtYiA-O564fR6DaSACT0A@mail.gmail.com>
Subject: [GIT PULL] 9p changes for 3.3 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

 Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
 git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Signed by tag for-linus-3.3-merge-window

There may be a conflict with some of Al's vfs-tree changes, Stephen
has a manual merge for linux next (https://lkml.org/lkml/2012/1/5/537)

Aneesh Kumar K.V (3):
     fs/9p: v9fs_stat2inode should update suid/sgid bits.
     fs/9p: We should not allocate a new inode when creating hardlines.
     fs/9p: iattr_valid flags are kernel internal flags map them to 9p values.

Jim Garlick (1):
     fs/9p: check schedule_timeout_interruptible return value

Joe Perches (1):
     9p: Reduce object size with CONFIG_NET_9P_DEBUG

fs/9p/cache.c          |   64 +++++++-------
fs/9p/fid.c            |    8 +-
fs/9p/v9fs.c           |   59 ++++++------
fs/9p/vfs_addr.c       |   13 +--
fs/9p/vfs_dentry.c     |   12 +-
fs/9p/vfs_dir.c        |   13 +--
fs/9p/vfs_file.c       |   34 ++++----
fs/9p/vfs_inode.c      |  165 ++++++++++++++++++--------------
fs/9p/vfs_inode_dotl.c |  127 ++++++++++++++++---------
fs/9p/vfs_super.c      |   12 +-
fs/9p/xattr.c          |   16 ++--
include/net/9p/9p.h    |   28 ++----
net/9p/client.c        |  242 ++++++++++++++++++++++++------------------------
net/9p/error.c         |    6 +-
net/9p/mod.c           |   31 ++++++-
net/9p/protocol.c      |    8 +-
net/9p/trans_fd.c      |  113 ++++++++++++-----------
net/9p/trans_rdma.c    |   26 +++---
net/9p/trans_virtio.c  |   34 ++++----
net/9p/util.c          |    4 +-
20 files changed, 545 insertions(+), 470 deletions(-)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJPDKZ5AAoJEGQ1yQUIRaTOzJYQAMwlTM3WMr/qSblv9qVMM/Ts
YJDNksk2gwuwiNmyflSKAowBHvtsvaPv3O0Oey/upo42rCDSISP1jrjrXtkIDTqM
A8bKkgSiuN5diaRrA1TiDqgafOuZy15xtCu/DtCpHau4dTVo0n5eWp9/vzYDspdY
miJzZBA/0ykLer1pzBwHovady+WQabOACmzL9Yan+2SqcdqvQwBVo55G4pquM88T
i8vmLBbRH34cm81/s94wPvKIO2sVb7mjEAR1EpYTXuuHyprukIBZvuWAbK+u6fnZ
ZqZIkpIW16++BTMmRVbQK4TQMqm0gMaw9KkwPzthPVYFA5Mtv1ElqNR6O0NUphF3
eq2sm/VFshGQfiaIy3kZAbxm2lnCZk1gSUYEB9HpG73vqWVc/Tw1MxE/xpjAKsTg
70YezP89+1pbLZ9/vNjFZTptltw5eRloGan8UkfvsiugcD0/Qx6dJnW9ItQ9HG2p
81hmhkNObRzoeqzgUjz06kLnk6GQmMobUCb55/0+KYdVSw6fxMxaEgTUqcCL61Jg
9mone5NRiCL99FLoq6iLgMoaLcHm/puonRGw7iwlaY9ZabxwQI0Ws7uCT08/jDmK
b33M6vzeu55u6XzjpP3BDmC7aR1I0DYktWIsBOXDAl9yOTMaWXNMPwijAdGl/3Su
w8cSTTcFc4vw7oXwia6j
=0HOG
-----END PGP SIGNATURE-----
