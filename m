Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3ADVIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:08:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:35131 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab3ADVIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:08:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,412,1355126400"; 
   d="scan'208";a="270074366"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Lance Ortiz <lance.ortiz@hp.com>
Subject: [GIT PULL] Use perf/event tracing to report PCI Express advanced errors
Date: Fri, 04 Jan 2013 13:08:17 -0800
Message-Id: <50e744c134281a8f8@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-aer-trace

for you to fetch changes up to 2cced2d95961acd318e9395578a60ee424d9db80:

  aerdrv: Cleanup log output for AER (2013-01-03 14:35:41 -0800)

----------------------------------------------------------------
Use perf/event tracing to report PCI Express advanced errors.

----------------------------------------------------------------
Lance Ortiz (3):
      aerdrv: Trace Event for PCI Express Advanced Error Reporting
      aerdrv: Enhanced AER logging
      aerdrv: Cleanup log output for AER

 drivers/acpi/apei/cper.c               |   19 ++++++--
 drivers/pci/pcie/aer/aerdrv_errprint.c |   63 ++++++++++++++------------
 include/linux/aer.h                    |    4 +-
 include/trace/events/ras.h             |   77 ++++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+), 34 deletions(-)
 create mode 100644 include/trace/events/ras.h
