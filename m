Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab2CVXhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:37:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:13405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165Ab2CVXhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:37:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="120686957"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pstore change
Date: Thu, 22 Mar 2012 16:37:16 -0700
Message-Id: <4f6bb7ac30008c8848@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fde7d9049e55ab85a390be7f415d74c9f62dd0f9:

  Linux 3.3-rc7 (2012-03-10 13:49:52 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git pstore-for-linus

for you to fetch changes up to 381b872cf7942ab8c95de156ce403bd906f3915d:

  pstore: Introduce get_reason_str() to pstore (2012-03-16 15:36:59 -0700)

----------------------------------------------------------------
One pstore patch

----------------------------------------------------------------
Seiji Aguchi (1):
      pstore: Introduce get_reason_str() to pstore

 fs/pstore/platform.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)
