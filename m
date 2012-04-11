Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2DKKS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:18:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab2DKKS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:18:26 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 11 Apr 2012 11:18:27 +0100
Message-ID: <1334139507.2713.17.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patches,

Steve.

------------------------------------------------------------------------------
The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git master

Benjamin Poirier (1):
      GFS2: use depends instead of select in kconfig

Bob Peterson (3):
      GFS2: put glock reference in error patch of read_rindex_entry
      GFS2: Make sure rindex is uptodate before starting transactions
      GFS2: Allow caching of rindex glock

 fs/gfs2/Kconfig |    7 ++-----
 fs/gfs2/aops.c  |    4 ++--
 fs/gfs2/bmap.c  |    6 +++++-
 fs/gfs2/dir.c   |    4 ++++
 fs/gfs2/inode.c |   13 +++++++++++--
 fs/gfs2/rgrp.c  |    8 +++++---
 fs/gfs2/xattr.c |   12 ++++++++++++
 7 files changed, 41 insertions(+), 13 deletions(-)


