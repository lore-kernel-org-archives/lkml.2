Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab1JXQ3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 12:29:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35720 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab1JXQ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 12:29:17 -0400
MIME-Version: 1.0
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Mon, 24 Oct 2011 11:28:56 -0500
Message-ID: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
Subject: [GIT PULL] 9p changes fro merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://github.com/ericvh/linux.git for-next

Aneesh Kumar K.V (4):
      fs/9p: Update zero-copy implementation in 9p
      fs/9p: inode file operation is properly initialized init_special_inode
      fs/9p: Cleanup option parsing in 9p
      net/9p: Convert net/9p protocol dumps to tracepoints

Dan Carpenter (2):
      9p: move dereference after NULL check
      fs/9p: change an int to unsigned int

Nicolae Mogoreanu (1):
      9p: fix 9p.txt to advertise msize instead of maxdata

 Documentation/filesystems/9p.txt |    2 +-
 fs/9p/v9fs.c                     |   33 ++-
 fs/9p/vfs_dir.c                  |   14 +-
 fs/9p/vfs_inode.c                |    2 -
 include/net/9p/9p.h              |   14 +-
 include/net/9p/client.h          |    8 +-
 include/net/9p/transport.h       |   10 +-
 include/trace/events/9p.h        |  176 ++++++++++++++
 net/9p/client.c                  |  469 +++++++++++++++++++++++++++-----------
 net/9p/protocol.c                |   99 +-------
 net/9p/protocol.h                |    4 +-
 net/9p/trans_common.c            |   53 ++---
 net/9p/trans_common.h            |   21 +--
 net/9p/trans_virtio.c            |  319 +++++++++++++++-----------
 14 files changed, 772 insertions(+), 452 deletions(-)
 create mode 100644 include/trace/events/9p.h
