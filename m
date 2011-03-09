Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab1CIPND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:13:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:32411 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1CIPNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:13:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,291,1297065600"; 
   d="scan'208";a="718220664"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] perf: PEBS events cleanup
Date: Wed,  9 Mar 2011 23:21:27 +0800
Message-Id: <1299684089-22835-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] perf: x86, SandyBridge PEBS events cleanup
[PATCH 2/2] perf: x86, use INTEL_*_CONSTRAINT for all PEBS event constraints

Thanks,
Lin Ming
