Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1B1L6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:58:39 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44812 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1B1L6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:58:38 -0500
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [GIT PULL] fuse fixes for 2.6.38
Message-Id: <E1Pu1kH-0005m1-UP@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Feb 2011 12:58:33 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

to receive the following fuse fixes.

Thanks,
Miklos
----


Miklos Szeredi (2):
      fuse: fix hang of single threaded fuseblk filesystem
      fuse: fix truncate after open

---
 fs/fuse/dir.c    |    7 +++++--
 fs/fuse/file.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/fuse_i.h |    6 +++++-
 3 files changed, 55 insertions(+), 10 deletions(-)
