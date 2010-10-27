Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0J0Vyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:54:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:18975 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab0J0Vyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:54:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,248,1286175600"; 
   d="scan'208";a="620954679"
From: Darren Hart <dvhart@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Fleming <matt@console-pimps.org>, tglx@linutronix.de,
        peterz@infradead.org, mingo@elte.hu, eric.dumazet@gmail.com,
        jkacur@redhat.com
Subject: [PATCH 0/3] futex: compiler warning and cleanups
Date: Wed, 27 Oct 2010 14:54:23 -0700
Message-Id: <1288216466-14309-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches include a compiler warning fix and a couple futex cleanups
that I have been sitting on for too long.

Darren Hart (3):
      futex: fix compiler warnings in exit_robust_list
      futex: replace fshared and clockrt with combined flags
      futex: add futex_q static initializer

 kernel/futex.c |  226 ++++++++++++++++++++++++++------------------------------
 1 files changed, 106 insertions(+), 120 deletions(-)


