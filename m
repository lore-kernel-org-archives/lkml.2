Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1ITBjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 21:39:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:52041 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab1ITBjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 21:39:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="50392835"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 0/8] ACPI, APEI patches for 3.2
Date: Tue, 20 Sep 2011 09:38:53 +0800
Message-Id: <1316482741-21799-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/8] ACPI, APEI, Print resource errors in conventional
[PATCH 2/8] ACPI, APEI, Remove table not found message
[PATCH 3/8] ACPI, Record ACPI NVS regions
[PATCH 4/8] ACPI, APEI, Resolve false conflict between ACPI NVS
[PATCH 5/8] ACPI, APEI, EINJ, Fix resource conflict on some
[PATCH 6/8] ACPI, Add RAM mapping support to ACPI atomic IO
[PATCH 7/8] ACPI, APEI, GHES: Add PCIe AER recovery support
[PATCH 8/8] ACPI, APEI, GHES, Distinguish interleaved error report
