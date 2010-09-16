Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab0IPWpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:45:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab0IPWpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:45:15 -0400
From: Jan Kara <jack@suse.cz>
To: Jens@suse.cz, "Axboe <axboe"@kernel.dk
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/3] BDI handling fixes
Date: Fri, 17 Sep 2010 00:44:08 +0200
Message-Id: <1284677051-28564-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  series of these three patches fixes the warning in __mark_inode_dirty()
which happens when I do e.g. touch /dev/zero. The first two patches should
be obvious enough and probably worth merging independently of the third
patch. The third patch is upto a discussion whether we want to solve the
problem that way or differently. Christoph, I know we spoke at LSF that
inode_to_bdi() could be a per-sb method but the current version of the
patch seems clean enough to me that we could maybe go even without the
special callback?

								Honza
