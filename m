Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1F0I1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:27:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:21556 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab1F0I0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,431,1304319600"; 
   d="scan'208";a="19009059"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, mjg59@srcf.ucam.org
Subject: [PATCH -v2 0/4] ACPI, APEI, Add APEI related _OSC support
Date: Mon, 27 Jun 2011 16:25:56 +0800
Message-Id: <1309163160-3201-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

- Change error message for WHEA _OSC call according to Matthew's comments

[PATCH -v2 1/4] ACPI, APEI, GHES, Prevent GHES to be built as module
[PATCH -v2 2/4] ACPI, APEI, GHES, Support disable GHES at boot time
[PATCH -v2 3/4] ACPI, APEI, Add APEI bit support in generic _OSC call
[PATCH -v2 4/4] ACPI, APEI, Add WHEA _OSC support
