Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1KHCjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:39:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:44114 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1KHCjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:39:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,473,1315206000"; 
   d="scan'208";a="34288577"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 0/8] ACPI, APEI patches for 3.2 (Resend)
Date: Tue,  8 Nov 2011 10:39:25 +0800
Message-Id: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend it because of kernel.org failure before.

[PATCH 1/9] ACPI, APEI, Print resource errors in conventional
[PATCH 2/9] ACPI, APEI, Remove table not found message
[PATCH 3/9] ACPI, Record ACPI NVS regions
[PATCH 4/9] ACPI, APEI, Resolve false conflict between ACPI NVS
[PATCH 5/9] ACPI, APEI, EINJ, Fix resource conflict on some
[PATCH 6/9] ACPI, Add RAM mapping support to ACPI atomic IO
[PATCH 7/9] ACPI, APEI, EINJ, Refine the fix of resource conflict
[PATCH 8/9] ACPI, APEI, GHES: Add PCIe AER recovery support
[PATCH 9/9] ACPI, APEI, GHES, Distinguish interleaved error report
