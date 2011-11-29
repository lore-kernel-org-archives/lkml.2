Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1K2AIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:08:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:20493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab1K2AIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:08:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="80881341"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fix for warning when CONFIG_PSTORE=n
Date: Mon, 28 Nov 2011 16:08:36 -0800
Message-Id: <4ed422841910324fef@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git for-linus
	HEAD=eee628da2ee3cbba6f14696278c92a464239eea6

This will update the file shown below.

Thanks!

-Tony

 drivers/firmware/efivars.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Christoph Fritz (1):
      efivars: add missing parameter to efi_pstore_read()

