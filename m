Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1HaWVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:21:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:5774 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab1HaWVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:21:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,309,1312182000"; 
   d="scan'208";a="47276820"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 0/5] Yet another pass at machine check recovery
Date: Wed, 31 Aug 2011 15:21:37 -0700
Message-Id: <4e5eb3f12101199595@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scaled down ambitions ... this version just goes for recovery of
data errors detected in user mode.

-Tony

 arch/x86/include/asm/thread_info.h        |    4 -
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   14 ++++
 arch/x86/kernel/cpu/mcheck/mce.c          |   91 ++++++++++++++++--------------
 arch/x86/kernel/signal.c                  |    6 -
 mm/memory-failure.c                       |   39 +++++++-----
 5 files changed, 86 insertions(+), 68 deletions(-)
