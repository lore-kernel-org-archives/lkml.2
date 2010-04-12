Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab0DLTUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:20:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:36464 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab0DLTUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:20:11 -0400
Date: Mon, 12 Apr 2010 21:20:18 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] UDF fixes
Message-ID: <20100412192018.GM3404@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get:

Dan Carpenter (1):
      udf: potential integer overflow

Dmitry Monakhov (1):
      udf: add speciffic ->setattr callback

The diffstat is

 fs/udf/balloc.c  |   10 ++++------
 fs/udf/file.c    |    2 +-
 fs/udf/inode.c   |    2 +-
 fs/udf/namei.c   |    9 ++++++++-
 fs/udf/udfdecl.h |    3 ++-
 5 files changed, 16 insertions(+), 10 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
