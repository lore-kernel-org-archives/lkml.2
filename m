Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1K1TZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:25:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:2330 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab1K1TZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:25:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="80782279"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fix pstore regression
Date: Mon, 28 Nov 2011 11:24:49 -0800
Message-Id: <4ed3e00124833cc877@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git for-linus
	HEAD=f6f8285132907757ef84ef8dae0a1244b8cde6ac

This will update the files shown below.

Thanks!

-Tony

 drivers/acpi/apei/erst.c   |   31 ++++++++++++++++++++++---------
 drivers/firmware/efivars.c |    9 +++++++--
 fs/pstore/platform.c       |   13 ++++++++-----
 include/linux/pstore.h     |    4 +++-
 4 files changed, 40 insertions(+), 17 deletions(-)

Kees Cook (1):
      pstore: pass allocated memory region back to caller

