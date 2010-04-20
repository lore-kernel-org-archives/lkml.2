Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0DTQhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:37:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab0DTQhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:37:47 -0400
Date: Tue, 20 Apr 2010 18:37:47 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] Quota fix for 2.6.34-rc5
Message-ID: <20100420163747.GC3885@quack.suse.cz>
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

  to get:

Jan Kara (1):
      quota: Convert __DQUOT_PARANOIA symbol to standard config option

The diffstat is

 fs/quota/Kconfig |    8 ++++++++
 fs/quota/dquot.c |   16 +++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

  I think it will save us quite some emails of type "How do I get rid of this
warning"...

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
