Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2LKREm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:04:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:35468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab2LKREl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:04:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,260,1355126400"; 
   d="scan'208";a="262478162"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] ACPI5 error injection fix
Date: Tue, 11 Dec 2012 09:04:40 -0800
Message-Id: <50c767a8438e8cf1@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b69f0859dc8e633c5d8c06845811588fe17e68b3:

  Linux 3.7-rc8 (2012-12-03 11:22:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-einj-fix-for-acpi5

for you to fetch changes up to 112f1fc08d0b3f81c594af617d88c0db6ce0873c:

  ACPI, APEI, EINJ: Add missed ACPI5 support for error trigger table (2012-12-07 11:50:02 -0800)

----------------------------------------------------------------
Trivial fix for error injection code using ACPI5 version of EINJ

----------------------------------------------------------------
Chen Gong (1):
      ACPI, APEI, EINJ: Add missed ACPI5 support for error trigger table

 drivers/acpi/apei/einj.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
