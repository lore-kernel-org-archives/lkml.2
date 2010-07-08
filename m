Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab0GHNko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:40:44 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35080 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab0GHNkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:40:42 -0400
Message-ID: <4C35D559.3040406@fusionio.com>
Date: Thu, 08 Jul 2010 15:40:41 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block/io bits for 2.6.35
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Last fixes for this kernel, I believe.

This includes two regression fixes for splice, along with the writeback
fixes that we talked about a few days ago.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Changli Gao (2):
      splice: direct_splice_actor() should not use pos in sd
      splice: check f_mode for seekable file

Christoph Hellwig (3):
      writeback: remove writeback_inodes_wbc
      writeback: split writeback_inodes_wb
      writeback: simplify the write back thread queue

Randy Dunlap (1):
      fs-writeback: fix kernel-doc warnings

 fs/afs/write.c              |    1 -
 fs/btrfs/extent_io.c        |    2 -
 fs/fs-writeback.c           |  335 ++++++++++++++-----------------------------
 fs/splice.c                 |    9 +-
 include/linux/backing-dev.h |    2 -
 include/linux/writeback.h   |    7 +-
 mm/backing-dev.c            |   17 +--
 mm/page-writeback.c         |    3 +-
 8 files changed, 122 insertions(+), 254 deletions(-)

-- 
Jens Axboe

