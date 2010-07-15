Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab0GOOah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:30:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933300Ab0GOOaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:30:35 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 15 Jul 2010 15:35:42 +0100
Message-ID: <1279204542.2466.18.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 fixes,

Steve.

The following changes since commit 2f7989efd4398d92b8adffce2e07dd043a0895fe:

  Merge master.kernel.org:/home/rmk/linux-2.6-arm (2010-07-14 17:28:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Abhijith Das (1):
      GFS2: BUG in gfs2_adjust_quota

Bob Peterson (4):
      GFS2: O_TRUNC not working on stuffed files across cluster
      GFS2: recovery stuck on transaction lock
      GFS2: Fix kernel NULL pointer dereference by dlm_astd
      GFS2: rename causes kernel Oops

 fs/gfs2/bmap.c  |    1 +
 fs/gfs2/dir.c   |    2 +-
 fs/gfs2/glock.c |   10 ++++++++++
 fs/gfs2/inode.c |   12 ++++++++----
 fs/gfs2/quota.c |    8 +++-----
 5 files changed, 23 insertions(+), 10 deletions(-)


