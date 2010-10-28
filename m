Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab0J1LaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:30:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab0J1LaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:30:20 -0400
Date: Thu, 28 Oct 2010 07:30:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] two small hfsplus fixes
Message-ID: <20101028113017.GA19160@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One regression fix for the locking changes in the previous pull
requests, and a one liner fix to properly free space for files unlinked
while open.

The following changes since commit 35da7a307c535f9c2929cae277f3df425c9f9b1e:

  Merge branch 'for-2.6.37/core' of git://git.kernel.dk/linux-2.6-block (2010-10-23 11:55:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus.git for-next

Christoph Hellwig (1):
      hfsplus: free space correcly for files unlinked while open

Dan Carpenter (1):
      hfsplus: fix double lock typo in ioctl

 fs/hfsplus/dir.c   |    4 +++-
 fs/hfsplus/ioctl.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)
