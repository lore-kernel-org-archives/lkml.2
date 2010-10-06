Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab0JFJoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:44:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45220 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0JFJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:44:03 -0400
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [GIT PULL] fuse fix for 2.6.36
Message-Id: <E1P3QXW-0006ca-SK@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 06 Oct 2010 11:43:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

to get the following fix.

Thanks,
Miklos
----


Geert Uytterhoeven (1):
      fuse: Initialize total_len in fuse_retrieve()

---
 fs/fuse/dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
