Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0EYJhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab0EYJhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:37:19 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 25 May 2010 09:51:27 +0100
Message-ID: <1274777487.2439.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following three GFS2 fixes,

Steve.

-------------------------------------------------------------------------------
The following changes since commit d7dbf4ffee1c7a17e2e5b5f01efe76fbd1671db6:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ryusuke/nilfs2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Bob Peterson (1):
      GFS2: Rework reclaiming unlinked dinodes

Steven Whitehouse (2):
      GFS2: Don't "get" xattrs for ACLs when ACLs are turned off
      GFS2: Fix permissions checking for setflags ioctl()

 fs/gfs2/acl.c   |    4 ++++
 fs/gfs2/file.c  |    7 +++++++
 fs/gfs2/inode.c |   54 +++++++++++++++++++++++++++++-------------------------
 fs/gfs2/inode.h |    3 +--
 fs/gfs2/log.c   |    2 +-
 fs/gfs2/log.h   |   29 +++++++++++------------------
 fs/gfs2/rgrp.c  |   20 ++++++++++++--------
 7 files changed, 65 insertions(+), 54 deletions(-)


