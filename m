Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2ECMsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:48:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab2ECMse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:48:34 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7 v3] writeback: Avoid iput() from flusher thread
Date: Thu,  3 May 2012 14:47:54 +0200
Message-Id: <1336049283-5859-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  this is a third iteration of my patch series for getting rid of iput() from
flusher thread. I think all the comments should be addressed. So please have
a look.

Changes since v2:
  * split last patch into two - move of inode_sync_wait() and change of
    inode_sync_wait() logic
  * added patch renaming end_writeback() to clear_inode()
  * couple of minor changes in comments, function names, ...

Changes since v1:
  * contents of last two patches from my previous submission split to several
    patches
  * changed some calling conventions
  * fixed a couple of bugs I found in the process

								Honza

