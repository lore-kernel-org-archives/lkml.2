Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1AKUQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:16:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49046 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1AKUP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:15:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=REOnFDj1GGwvqU2ru+Ct03DYzfoc3mKrl9oO1GclLjvfagFDLJO8h4IzBMsI+ZA5bM
         auRv3qZkVsOUS6qMlSTTM58NKP5AQcGNYPUbqT1o996cxV5VCf4QXqzmAFY6ClkOxJkn
         znI6jZy7hOfbZ1RoieZnHL+HBgfNTcNPPZwPE=
MIME-Version: 1.0
Date: Tue, 11 Jan 2011 14:15:57 -0600
Message-ID: <AANLkTim-2Sr+dgKjKtbQGgJ8C-YEGkRcgb4Q9QFgtcXx@mail.gmail.com>
Subject: [GIT PULL] 9p file system changes for the merge window
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5b2eef966cb2ae307aa4ef1767f7307774bc96ca:

  Merge branch 'drm-core-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
(2011-01-10 17:11:39 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (4):
      fs/9p: Fix the return error on default acl removal
      fs/9p: Move dotl inode operations into a seperate file
      fs/9p: Simplify the .L create operation
      fs/9p: Don't set dentry->d_op in create routines

Eric Van Hensbergen (1):
      fs/9p: fix spelling typo

Joe Perches (1):
      fs/9p: Remove unnecessary semicolons

M. Mohan Kumar (2):
      net/9p: Use proper data types
      fs/9p: TREADLINK bugfix

Randy Dunlap (1):
      fs/9p: fix menu presentation

 fs/9p/Kconfig          |    5 +-
 fs/9p/Makefile         |    1 +
 fs/9p/acl.c            |    4 +-
 fs/9p/v9fs.h           |   42 +++-
 fs/9p/vfs_inode.c      |  871 +-----------------------------------------------
 fs/9p/vfs_inode_dotl.c |  824 +++++++++++++++++++++++++++++++++++++++++++++
 fs/9p/xattr.c          |    2 +-
 net/9p/protocol.c      |   22 +-
 8 files changed, 887 insertions(+), 884 deletions(-)
 create mode 100644 fs/9p/vfs_inode_dotl.c
