Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2AaWmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:42:20 -0500
Received: from [206.117.179.246] ([206.117.179.246]:54171 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753352Ab2AaWmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:42:19 -0500
From: Joe Perches <joe@perches.com>
To: codalist@TELEMANN.coda.cs.cmu.edu, linux-mtd@lists.infradead.org,
        reiserfs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] fs: Remove unnecessary OOM messages
Date: Tue, 31 Jan 2012 14:42:06 -0800
Message-Id: <cover.1328049542.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (4):
  coda: Remove unnecessary OOM messages
  jffs2: Remove unnecessary OOM messages
  reiserfs: Remove unnecessary OOM messages
  udf: Remove unnecessary OOM messages

 fs/coda/coda_linux.h  |   13 ++++++-------
 fs/jffs2/compr_lzo.c  |    1 -
 fs/jffs2/compr_zlib.c |    6 ++----
 fs/reiserfs/journal.c |    8 ++------
 fs/reiserfs/resize.c  |    1 -
 fs/udf/super.c        |    5 +----
 6 files changed, 11 insertions(+), 23 deletions(-)

-- 
1.7.8.111.gad25c.dirty

