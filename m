Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab0KJGNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 01:13:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:29184 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0KJGNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 01:13:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,177,1288594800"; 
   d="scan'208";a="625286606"
Subject: [RFC PATCH 0/2] Use event group to simulate PMI
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Matt Fleming <matt@console-pimps.org>
Cc: Zhang Rui <rui.zhang@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 14:14:52 +0800
Message-ID: <1289369692.2430.35.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

The followed 2 patches are based on the discussions at:
http://marc.info/?l=linux-kernel&m=128220854801819&w=2
http://marc.info/?l=linux-kernel&m=128317758627990&w=2

[RFC PATCH 1/2] perf: Enable group siblings on exec if attr::enable_on_exec set
[RFC PATCH 2/2] perf stat: Use event group to simulate PMI on PMI-less hardware counter

Any comments?

Thanks,
Lin Ming

