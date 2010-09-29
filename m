Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0I2LyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:54:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:51878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab0I2LyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:54:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,252,1283756400"; 
   d="scan'208";a="559001982"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH -v2 0/5] ACPI, APEI, BUG fixes for 2.6.36
Date: Wed, 29 Sep 2010 19:53:50 +0800
Message-Id: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Len,

This patchset is version 2 of some BUG fixes about APEI for 2.6.36.
Can you merge it?

[PATCH -v2 1/5] ACPI, APEI, Fix APEI related table size checking
[PATCH -v2 2/5] ACPI, APEI, Fix acpi_pre_map() return value
[PATCH -v2 3/5] ACPI, APEI, HEST Fix the unsuitable usage of platform_data
[PATCH -v2 4/5] ACPI, APEI, Fix error path for memory allocation
[PATCH -v2 5/5] ACPI, APEI, Fix ERST MOVE_DATA instruction implementation

Best Regards,
Huang Ying
