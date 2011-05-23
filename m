Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1EWOE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab1EWOE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:04:56 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 23 May 2011 15:05:55 +0100
Message-ID: <1306159555.2791.17.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These two changes just missed out on the last pull request. Please
consider pulling the following two fixes,

Steve.


-----------------------------------------------------------------------------
The following changes since commit c21fd1a8c68ce3f49b00caf10337169262cfb8ad:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-05-21 00:13:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (2):
      GFS2: Wipe directory hash table metadata when deallocating a directory
      GFS2: Wait properly when flushing the ail list

 fs/gfs2/bmap.c |    2 ++
 fs/gfs2/log.c  |   29 ++++++++++++++++++++++++++---
 fs/gfs2/rgrp.c |    4 ++++
 3 files changed, 32 insertions(+), 3 deletions(-)


