Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935639Ab1ETS7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:59:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:61048 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934808Ab1ETS7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:59:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,243,1304319600"; 
   d="scan'208";a="4665951"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [git pull] pstore and ia64 changes
Date: Fri, 20 May 2011 11:58:41 -0700
Message-Id: <4dd6b9e1199552af9d@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git release

This will update the files shown below.

Thanks!

-Tony

 arch/ia64/kernel/vmlinux.lds.S |    1 +
 arch/ia64/oprofile/backtrace.c |    2 +-
 drivers/acpi/apei/Kconfig      |    1 +
 drivers/acpi/apei/erst.c       |   61 +++++++++++++++++++++++++++++----------
 fs/pstore/platform.c           |   12 ++++++--
 include/linux/pstore.h         |    4 ++-
 6 files changed, 60 insertions(+), 21 deletions(-)

Chen Gong (3):
      pstore: fix one type of return value in pstore
      pstore: fix pstore filesystem mount/remount issue
      pstore: fix potential logic issue in pstore read interface

Tony Luck (3):
      [IA64] fix build warning in arch/ia64/oprofile/backtrace.c
      pstore: Fix Kconfig dependencies for apei->pstore
      [IA64] define "_sdata" symbol

