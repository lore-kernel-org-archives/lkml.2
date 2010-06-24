Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0FXXYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 19:24:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:57891 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab0FXXYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 19:24:44 -0400
Date: Fri, 25 Jun 2010 01:24:17 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: [PULL] Trivial ext2 & ext3 fix for 2.6.35-rc4
Message-ID: <20100624232417.GG3345@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get to two trivial one-liners:

Jan Kara (1):
      ext2: update ctime when changing the file's permission by setfacl

Miao Xie (1):
      ext3: update ctime when changing the file's permission by setfacl

The diffstat is

 fs/ext2/acl.c |    1 +
 fs/ext3/acl.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
