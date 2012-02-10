Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab2BJQEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:04:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab2BJQEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:04:16 -0500
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Generic O_SYNC AIO DIO handling
Date: Fri, 10 Feb 2012 17:03:58 +0100
Message-Id: <1328889842-23231-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Jeff,

  these patches implement generic way of handling O_SYNC AIO DIO. They work
for all filesystems except for ext4 and xfs. Thus together with your patches,
all filesystems should handle O_SYNC AIO DIO correctly. I've tested ext3,
btrfs, and xfs (to check that I didn't break anything when the generic code
is unused) and things seem to work fine. Will you add these patches to your
series please? Thanks.

								Honza
