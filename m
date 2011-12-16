Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab1LPTZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:25:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:6782 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab1LPTZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:25:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97088711"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [git pull] RAS changes (queue for 3.3)
Date: Fri, 16 Dec 2011 11:25:53 -0800
Message-Id: <4eeb9b412912414dcf@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Kicking the tires on the new version of the RAS tree at kernel.org 2.0 (so
please say if you'd like to see my "please pull" script to format this e-mail
differently).

Only one patch for this test - you said you liked it in https://lkml.org/lkml/2011/12/9/24

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-inject
	HEAD=2c29d9dd577b74b44e580f957ea44d1df73af23a

This will update the files shown below.

Thanks!

-Tony

 arch/x86/include/asm/mce.h              |    9 ++++---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   34 +++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 8 deletions(-)

Chen Gong (1):
      x86: add IRQ context simulation in module mce-inject

