Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab0HERDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:03:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933754Ab0HERCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:02:54 -0400
Date: Thu, 5 Aug 2010 19:02:23 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] UDF changes for 2.6.36
Message-ID: <20100805170222.GF3535@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git
for_linus

  to get two minor cleanups:

Huang Weiyi (1):
      udf: remove duplicated #include

Justin P. Mattock (1):
      udf: super.c Fix warning: variable 'sbi' set but not used

The diffstat is

 fs/udf/file.c  |    1 -
 fs/udf/super.c |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
