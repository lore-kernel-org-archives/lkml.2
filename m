Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab1CXQ3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:29:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:54847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab1CXQ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:29:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,237,1299484800"; 
   d="scan'208";a="724698606"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [git pull] ia64 changes
Date: Thu, 24 Mar 2011 09:29:44 -0700
Message-Id: <4d8b71781902177d76@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git release

This will update the files shown below.

Thanks!

-Tony

 arch/ia64/include/asm/unistd.h |    6 +++++-
 arch/ia64/kernel/entry.S       |    4 ++++
 fs/pstore/platform.c           |   15 ++++++++++++---
 3 files changed, 21 insertions(+), 4 deletions(-)

Tony Luck (2):
      [IA64] New syscalls for 2.6.39
      pstore: cleanups to pstore_dump()

