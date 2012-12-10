Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2LJJHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:07:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:35781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab2LJJHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:07:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="229269903"
From: Adrian Hunter <adrian.hunter@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] mmc: sdhci-acpi: enable runtime-pm for device HID INT33C6
Date: Mon, 10 Dec 2012 11:10:43 +0200
Message-Id: <1355130644-26065-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is a minor hardware ID addition to sdhci-acpi.

Please consider this for Linux 3.8, in which case it must go via
Rafael's linux-pm tree because that is where the new driver is.


Adrian Hunter (1):
      mmc: sdhci-acpi: enable runtime-pm for device HID INT33C6

 drivers/mmc/host/sdhci-acpi.c | 8 ++++++++
 1 file changed, 8 insertions(+)


Regards
Adrian Hunter
