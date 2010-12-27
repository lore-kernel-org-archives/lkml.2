Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0L0Pfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:35:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:5230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab0L0Pfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:35:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,234,1291622400"; 
   d="scan'208";a="872196795"
Subject: [PATCH 0/7] perf: offcore and load latency monitoring patches
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Dec 2010 23:35:31 +0800
Message-Id: <1293464131.2695.100.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

This series includes Andi's offcore patches and my load latency monitoring patch.
And also some incremental patches on top of Andi's patches per Peter's comments.

The entry of the first version,
[RFC PATCH] perf: Add load latency monitoring on Intel
http://marc.info/?l=linux-kernel&m=129300537003611&w=2

[PATCH 1/7] perf: Document enhanced event encoding for OFFCORE_MSR
[PATCH 2/7] perf-events: Add support for supplementary event registers v4
[PATCH 3/7] perf-events: Fix LLC-* events on Intel Nehalem/Westmere v2
[PATCH 4/7] perf: Check if HT is supported and enabled
[PATCH 5/7] perf: Optimize topology iteration
[PATCH 6/7] perf: Use MSR names in the extra reg lists
[PATCH 7/7] perf: Add load latency monitoring on Intel Nehalem/Westmere v2

Thanks for review and feedback.
Lin Ming






