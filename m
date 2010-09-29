Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0I2RJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:09:14 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55572 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab0I2RJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:09:12 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201009291709.o8TH98Cf002604@stout.americas.sgi.com>
Date: Wed, 29 Sep 2010 12:09:07 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.36-rc7
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please consider pulling the following change in XFS for
2.6.36.  It fixes a bug that could cause file system corruption in
the event of a crash when the new delayed logging functionality is
enabled.  I re-based and re-tested it this morning, but it was
subjected to additional testing previously.  Thanks.

					-Alex

The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:

  Linux 2.6.36-rc6 (2010-09-28 18:01:22 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: force background CIL push under sustained load

 fs/xfs/xfs_log_cil.c  |   12 +++++++++---
 fs/xfs/xfs_log_priv.h |   37 +++++++++++++++++++++----------------
 2 files changed, 30 insertions(+), 19 deletions(-)
