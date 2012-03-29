Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2C2GKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:10:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:33857 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab2C2GJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:09:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="126409892"
From: Lin Ming <ming.m.lin@intel.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] ACPI/PM D3Cold state support
Date: Thu, 29 Mar 2012 14:09:37 +0800
Message-Id: <1333001380-6050-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ZPODD patch set involves 4 subsystems: ACPI, Generic PM, SATA and SCSI.
This makes it hard to push upstream.

So I decide to seprate it to two patch sets, one for ACPI/PM and the other
for SATA/SCSI.

You can find the SATA/SCSI part at:
[PATCH v3 0/7] SATA ZPODD support
https://lkml.org/lkml/2012/3/28/20

[PATCH v3 1/3] ACPI: Introduce ACPI D3_COLD state support
[PATCH v3 2/3] ACPI: Add interface to register/unregister device to/from power resources
[PATCH v3 3/3] PM / Runtime: Add may_power_off flag to subsys data

Rafael,

Would you ack PATCH 3?
I renamed the flag to may_power_off according to Alan's suggestion.

Thanks,
Lin Ming
