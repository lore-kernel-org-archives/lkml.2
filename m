Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1FCRF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:05:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49474 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab1FCRFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:05:21 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Fri,  3 Jun 2011 13:04:34 -0400
Message-Id: <1307120674-5504-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1fa7b6a29c61358cc2ca6f64cef4aa0e1a7ca74c:

  Revert "mm: fail GFP_DMA allocations when ZONE_DMA is not configured" (2011-06-02 06:11:24 +0900)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Steven Miao (1):
      Blackfin: strncpy: fix handling of zero lengths

 arch/blackfin/lib/strncpy.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
