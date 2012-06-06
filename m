Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab2FFPzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:55:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:47640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248Ab2FFPzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:55:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161755251"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/7] affs: stop using write_supers and s_dirt
Date: Wed,  6 Jun 2012 18:56:50 +0300
Message-Id: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the patch-set. Please, see v1 for the high-level description.

v1->v2:
 Address review comments from Jan Kara:
 * use BH lock for locking the superblock while calculating its checksum;
 * stop setting bm_flags

v1: http://lkml.org/lkml/2012/6/5/162

 fs/affs/affs.h   |    7 +++++
 fs/affs/bitmap.c |    4 +-
 fs/affs/super.c  |   68 +++++++++++++++++++++++++++++++++++-------------------
 3 files changed, 53 insertions(+), 26 deletions(-)

Thanks,
Artem.
