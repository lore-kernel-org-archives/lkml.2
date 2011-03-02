Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1CBKNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:13:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:52146 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab1CBKNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:13:18 -0500
Date: Wed, 2 Mar 2011 11:13:17 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] Fix for ext2 fs corruption under rename load
Message-ID: <20110302101317.GB7496@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git
for_linus

to get a fix for a long-standing ext2 bug causing fs corruption. The
corruption isn't severe (only i_nlink gets corrupted) but still it isn't
nice thus I push the fix this late in the cycle.

The full shortlog is:

Josh Hunt (1):
      ext2: Fix link count corruption under heavy link+rename load

The diffstat is

 fs/ext2/namei.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
