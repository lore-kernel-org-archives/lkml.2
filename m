Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1DOWCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:02:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43342 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab1DOWCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Uj6fjCYLb/PwsPAvh7X/C1FkmCqe0Xn2VVXDk91AmO34LUHAjOe+YtxTJgOuX2XLuD
         bBbPTBSNBeavb7f4n7Ukgunf/hDy4hoCyOT1HjMNc4YLf6EYSDnrrIzzLfVnC4E+3Y9i
         kkES0GjG0Gdy6LOO8mMc0AP6x5hIoZcdTWaxg=
MIME-Version: 1.0
Date: Fri, 15 Apr 2011 17:02:16 -0500
Message-ID: <BANLkTikrEVch9jmwpg4x3NGn03p1hHyC-w@mail.gmail.com>
Subject: [GIT PULL] 9p: fixes for -rc3
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
   Here's some fixes for the -rc stream, sorry these have been a bit
delayed due to a new baby killing my productivity and my normal sleep
patterns :)

The following changes since commit 5853b4f06f7b9b56f37f457d7923f7b96496074e:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block
(2011-04-15 08:01:13 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (5):
      fs/9p: Fix revalidate to return correct value
      fs/9p: Use write_inode for data sync on server
      9p: revert tsyncfs related changes
      fs/9p: Fix error reported by coccicheck
      9p: Fix sparse error

Harsh Prateek Bora (1):
      net/9p: nwname should be an unsigned int

 fs/9p/fid.c             |   15 +-------
 fs/9p/v9fs.h            |    1 -
 fs/9p/vfs_dentry.c      |    4 ++-
 fs/9p/vfs_inode_dotl.c  |    2 +-
 fs/9p/vfs_super.c       |   80 +++++++++++++++++++++++++++++++++--------------
 include/net/9p/9p.h     |    2 -
 include/net/9p/client.h |    5 +--
 net/9p/client.c         |   29 ++--------------
 net/9p/protocol.c       |    7 ++--
 net/9p/trans_common.c   |    2 +-
 net/9p/trans_virtio.c   |   15 ++++++--
 11 files changed, 84 insertions(+), 78 deletions(-)
