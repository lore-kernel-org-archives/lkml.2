Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1F1BPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:15:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:49420 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab1F1BN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:13:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,435,1304319600"; 
   d="scan'208";a="19463975"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH 0/3] ACPI, APEI, Fixes for 3.0
Date: Tue, 28 Jun 2011 09:13:51 +0800
Message-Id: <1309223634-12248-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/3] ACPI, APEI, HEST, Detect duplicated hardware error source ID
[PATCH 2/3] ACPI, APEI, ERST, Prevent erst_dbg from loading if ERST is disabled
[PATCH 3/3] ACPI, APEI, ERST, Fix erst-dbg long record reading issue
