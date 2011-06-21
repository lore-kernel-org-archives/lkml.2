Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1FUHQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:16:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:15302 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab1FUHQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:16:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,399,1304319600"; 
   d="scan'208";a="16258813"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, mjg59@srcf.ucam.org
Subject: [PATCH 0/4] ACPI, APEI, Add APEI related _OSC support
Date: Tue, 21 Jun 2011 15:16:23 +0800
Message-Id: <1308640587-24502-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4] ACPI, APEI, GHES, Prevent GHES to be built as module
[PATCH 2/4] ACPI, APEI, GHES, Support disable GHES at boot time
[PATCH 3/4] ACPI, APEI, Add APEI bit support in generic _OSC call
[PATCH 4/4] ACPI, APEI, Add APEI _OSC support
