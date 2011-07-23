Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1GWQ2f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 12:28:35 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:63596 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1GWQ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 12:28:28 -0400
MIME-Version: 1.0
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Sat, 23 Jul 2011 11:28:07 -0500
Message-ID: <CAFkjPT=ZdAf99BYCfKMaVJmYRihheMc4-5D-Dez0sVkPoZ3p+A@mail.gmail.com>
Subject: [GIT PULL] 9p: changes for the 3.1 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hope you get to enjoy your vacation.  Enjoy some SCUBA SCUBA SCUBA for me.

       -eric


The following changes since commit bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-07-22
19:02:39 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (7):
      fs/9p: remove rename work around in 9p
      net/9p: Remove structure not used in the code
      fs/9p: Fid is not valid after a failed clunk.
      fs/9p: When doing inode lookup compare qid details and inode mode bits.
      fs/9p: Always ask new inode in create
      fs/9p: add 9P2000.L renameat operation
      fs/9p: add 9P2000.L unlinkat operation

Eric Van Hensbergen (2):
      net/9p: fix client code to fail more gracefully on protocol error
      9p: clean up packet dump code

Prem Karat (2):
      fs/9p: Fix invalid mount options/args
      fs/9p: Clean-up get_protocol_version() to use strcmp

Venkateswararao Jujjuri (JV) (1):
      net/9p: Fix the msize calculation.

jvrao (2):
      Fix the size of receive buffer packing onto VirtIO ring.
      VirtIO can transfer VIRTQUEUE_NUM of pages.

 fs/9p/cache.c              |   20 ++---
 fs/9p/cache.h              |    9 --
 fs/9p/v9fs.c               |   45 ++++++++---
 fs/9p/v9fs.h               |   29 ++++++-
 fs/9p/vfs_inode.c          |  118 +++++++++++++++++++--------
 fs/9p/vfs_inode_dotl.c     |   67 +++++++++++++---
 include/net/9p/9p.h        |  193 ++++----------------------------------------
 include/net/9p/client.h    |   12 ++-
 include/net/9p/transport.h |    2 +-
 net/9p/client.c            |  155 ++++++++++++++++++++++++++---------
 net/9p/mod.c               |    4 +-
 net/9p/protocol.c          |   44 ++++------
 net/9p/trans_virtio.c      |    4 +-
 13 files changed, 370 insertions(+), 332 deletions(-)
