Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab0IHKEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 06:04:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58337 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0IHKEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 06:04:13 -0400
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [git pull] fuse: fixes for 2.6.36
Message-Id: <E1OtHVj-0000jm-1b@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 08 Sep 2010 12:04:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

to get the following fuse fixes.

Thanks,
Miklos
----

Miklos Szeredi (2):
      fuse: flush background queue on connection close
      fuse: fix lock annotations

---
 fs/fuse/dev.c  |   42 ++++++++++++++++++++++++++----------------
 fs/fuse/file.c |    8 ++++----
 2 files changed, 30 insertions(+), 20 deletions(-)
