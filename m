Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab0EURuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:50:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:51961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577Ab0EURuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:50:12 -0400
Date: Fri, 21 May 2010 19:50:03 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] UDF update for 2.6.35-rc1
Message-ID: <20100521175003.GB10149@quack.suse.cz>
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

John Kacur (1):
      udf: BKL ioctl pushdown

The diffstat is

 fs/udf/dir.c     |    2 +-
 fs/udf/file.c    |   43 +++++++++++++++++++++++++++----------------
 fs/udf/udfdecl.h |    3 +--
 3 files changed, 29 insertions(+), 19 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
