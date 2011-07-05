Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab1GEKoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:44:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38421
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226Ab1GEKoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:44:16 -0400
Date: Tue, 5 Jul 2011 06:44:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] hfsplus regression fixes
Message-ID: <20110705104414.GA17713@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Linus,

please pull two small fixes for regressions introduced in the last
big batch of hfsplus updates in 2.6.38.


The following changes since commit ca56a95eedcc95f8fea7b49c87565cd961d74fe2:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-06-29 18:18:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus.git for-linus

Alexey Khoroshilov (1):
      hfsplus: Fix double iput of the same inode in hfsplus_fill_super()

Seth Forshee (1):
      hfsplus: add missing call to bio_put()

 fs/hfsplus/super.c   |    2 +-
 fs/hfsplus/wrapper.c |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)
