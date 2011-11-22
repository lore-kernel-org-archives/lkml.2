Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1KVSyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:54:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58883 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1KVSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:54:29 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 0/3] reiserfs: Reduce a bit reiserfs lock coverage on mount path
Date: Tue, 22 Nov 2011 19:54:16 +0100
Message-Id: <1321988059-13053-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up a bit the code and fixes a lock inversion.
No real regression fixed though so this is rather 3.3 material.

Thanks.

Frederic Weisbecker (3):
  reiserfs: Delay reiserfs lock until journal initialization
  reiserfs: Don't lock journal_init()
  reiserfs: Don't lock root inode searching

 fs/reiserfs/bitmap.c  |    3 --
 fs/reiserfs/journal.c |   53 ++++++++++++++++++-----------------------------
 fs/reiserfs/super.c   |   54 ++++++++++++++++++++++++++----------------------
 3 files changed, 49 insertions(+), 61 deletions(-)

-- 
1.7.5.4

