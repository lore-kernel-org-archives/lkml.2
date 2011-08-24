Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1HXNFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:05:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43737 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1HXNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:05:32 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Subject: [git pull] fuse fixes for 3.1
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Wed, 24 Aug 2011 15:05:27 +0200
Message-ID: <87ippnhsdk.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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


Johannes Weiner (2):
      fuse: delete dead .write_begin and .write_end aops
      fuse: mark pages accessed when written to

Miklos Szeredi (2):
      fuse: fix flock
      fuse: check size of FUSE_NOTIFY_INVAL_ENTRY message

Randy Dunlap (1):
      fuse: fix non-ANSI void function notation

---
 fs/fuse/dev.c        |    4 ++
 fs/fuse/file.c       |   84 ++++++++------------------------------------------
 fs/fuse/fuse_i.h     |    8 ++++-
 fs/fuse/inode.c      |   10 +++++-
 include/linux/fuse.h |    9 +++++-
 5 files changed, 40 insertions(+), 75 deletions(-)
