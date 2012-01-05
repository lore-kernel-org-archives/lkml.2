Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2AER3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:29:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:18553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab2AER3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:29:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92760806"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [git pull] pstore changes
Date: Thu, 05 Jan 2012 09:29:18 -0800
Message-Id: <4f05ddee2170273735@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git pstore
	HEAD=2174f6df7891fa331800beb72634c969f017900b

This will update the files shown below.

Thanks!

-Tony

 drivers/acpi/apei/erst.c   |    6 ++++--
 drivers/firmware/efivars.c |    8 +++++---
 fs/pstore/inode.c          |    3 ++-
 fs/pstore/platform.c       |   36 ++++--------------------------------
 include/linux/pstore.h     |   12 +++++-------
 5 files changed, 20 insertions(+), 45 deletions(-)

Kees Cook (2):
      pstore: pass reason to backend write callback
      pstore: gracefully handle NULL pstore_info functions

