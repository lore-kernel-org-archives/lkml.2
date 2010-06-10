Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666Ab0FJRKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:10:48 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50275 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759617Ab0FJRKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:10:47 -0400
Message-ID: <4C111C95.9020909@fusionio.com>
Date: Thu, 10 Jun 2010 19:10:45 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Subject: [GIT PULL] block/io bits for 2.6.35-rc #2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So lets try it one more time, this time without the writeback bits.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus2

Jens Axboe (1):
      block: remove duplicate BUG_ON() in bd_finish_claiming()

Miklos Szeredi (2):
      pipe: fix pipe buffer resizing
      pipe: fix check in "set size" fcntl

Nick Piggin (2):
      block: bd_start_claiming fix module refcount
      block: bd_start_claiming cleanup

 fs/block_dev.c |   72 +++++++++++++++++++++++++++++++++++++------------------
 fs/pipe.c      |   20 +++++++++++----
 2 files changed, 62 insertions(+), 30 deletions(-)

-- 
Jens Axboe

