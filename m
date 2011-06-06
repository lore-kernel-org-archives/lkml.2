Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab1FFNj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:39:27 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:33042 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab1FFNjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:39:25 -0400
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: [RFC PATCH V5 0/4] cpuidle: global registration of idle states with
	per-cpu statistics
To: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        santosh.shilimkar@ti.com, khilman@ti.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Mon, 06 Jun 2011 19:09:18 +0530
Message-ID: <20110606133917.5670.54949.stgit@tringupt.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series implements global registration of cpuidle
states, and also has the necessary data structure changes to
accommodate the per-cpu writable members of the cpuidle_states
structure.

Previous version of the series (V4) is at https://lkml.org/lkml/2011/4/28/312
This series applies on 3.0-rc1

Changes from previous version (V4):

1. Rebased the series to 3.0-rc1
2. Made same changes for Samsung exynos4 cpuidle driver registration

Tests done:
1. Compile tested for ARM using the following configs: da8xx_omapl_defconfig,
  exynos4_defconfig, kirkwood_defconfig, omap2plus_defconfig.

2. Boot tested on x86 nehalem with multiple C-states for both intel_idle
  and acpi_idle drivers.

Thanks
-Trinabh 
