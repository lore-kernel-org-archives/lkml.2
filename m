Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab2AIS03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 13:26:29 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54218 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932398Ab2AIS02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 13:26:28 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS bugfix for 3.3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20120109182623.7E2B5426DA7@whiskey.americas.sgi.com>
Date: Mon,  9 Jan 2012 12:26:23 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following bug fix for FITRIM operations in xfs.

Thanks,
	Ben

The following changes since commit c99516ca854770000c277b2680a15581c691e18c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: fix endian conversion issue in discard code

 fs/xfs/xfs_discard.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
