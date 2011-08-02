Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab1HBW0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:26:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:35632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab1HBW0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:26:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,307,1309762800"; 
   d="scan'208";a="37233287"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] pstore - fix warnings when CONFIG_PSTORE=n
Date: Tue, 02 Aug 2011 15:26:05 -0700
Message-Id: <4e38797d208183268f@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git pstore-efi

This will update the files shown below.

Thanks!

-Tony

 drivers/firmware/efivars.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Tony Luck (1):
      efivars: fix warnings when CONFIG_PSTORE=n

