Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2GKTCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab2GKTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:02:18 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: aris@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] userns: convert some filesystems to kuid/kgid 
Date: Wed, 11 Jul 2012 15:01:17 -0400
Message-Id: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this patchset converts 9p, ADFS, AFFS, AFS and autofs4 to use kuid and kgid.
I plan to work on the other pending filesystems too but wanted some feedback
on the first ones first.

These patches are based on
	git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git

 fs/9p/fid.c            |    3 +-
 fs/9p/v9fs.c           |   16 ++++++++++---
 fs/9p/vfs_inode.c      |   19 +++++++++------
 fs/9p/vfs_inode_dotl.c |   16 ++++++-------
 fs/adfs/inode.c        |   12 ++++++---
 fs/adfs/super.c        |   26 +++++++++++++--------
 fs/affs/inode.c        |   30 +++++++++++++-----------
 fs/affs/super.c        |   60 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/afs/fsclient.c      |    8 +++---
 fs/afs/inode.c         |    8 +++---
 fs/autofs4/inode.c     |   32 ++++++++++++++++++--------
 fs/autofs4/waitq.c     |    4 +--
 init/Kconfig           |    5 ----
 13 files changed, 161 insertions(+), 78 deletions(-)

