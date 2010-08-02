Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0HBHsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:48:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:53447 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab0HBHsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:48:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,302,1278313200"; 
   d="scan'208";a="591969992"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 0/4] ACPI, APEI, Some fixes and ERST debug support for 2.6.36
Date: Mon,  2 Aug 2010 15:48:21 +0800
Message-Id: <1280735305-15379-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4] ACPI, APEI, Fix a typo of error path of apei_resources_request
[PATCH 2/4] ACPI, APEI, Rename CPER and GHES severity constants
[PATCH 3/4] ACPI, APEI, Manage GHES as platform devices
[PATCH 4/4] ACPI, APEI, ERST debug support
